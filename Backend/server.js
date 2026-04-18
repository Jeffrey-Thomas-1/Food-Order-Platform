const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// MySQL Connection Pool (reads from environment variables)
// Create a Backend/.env file (or set env vars in your environment) with DB_HOST, DB_USER, DB_PASSWORD, DB_NAME
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'database',
  waitForConnections: true,
  connectionLimit: Number(process.env.DB_CONN_LIMIT) || 10,
  queueLimit: 0
});

const JWT_SECRET = process.env.JWT_SECRET || 'dev_secret_change_me';
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '1d';

function createToken(user) {
  return jwt.sign(
    {
      userId: user.id,
      email: user.email,
      username: user.username
    },
    JWT_SECRET,
    { expiresIn: JWT_EXPIRES_IN }
  );
}

function getBearerToken(req) {
  const authHeader = req.headers.authorization || '';
  if (!authHeader.startsWith('Bearer ')) {
    return null;
  }
  return authHeader.slice(7).trim();
}

function verifyToken(token) {
  return jwt.verify(token, JWT_SECRET);
}

function requireAuth(req, res, next) {
  const token = getBearerToken(req);
  if (!token) {
    return res.status(401).json({
      success: false,
      error: 'Authentication required'
    });
  }

  try {
    req.authUser = verifyToken(token);
    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      error: 'Invalid or expired token'
    });
  }
}

function generateReceiptNumber(orderId) {
  const stamp = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  return `REC-${stamp}-${orderId}`;
}

async function ensureCoreTables() {
  const conn = await pool.getConnection();
  try {
    await conn.execute(
      `CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(80) NOT NULL,
        email VARCHAR(120) NOT NULL UNIQUE,
        password_hash VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4`
    );
  } finally {
    conn.release();
  }
}

// Test database connection
pool.getConnection().then(conn => {
  console.log('✅ Connected to MySQL database');
  conn.release();
}).catch(err => {
  console.error('❌ Database connection failed:', err.message);
});

ensureCoreTables()
  .then(() => console.log('✅ Core tables verified'))
  .catch(err => console.error('❌ Table setup failed:', err.message));

// ===========================
// API ENDPOINTS
// ===========================

// GET all foods (with optional category filter)
app.get('/api/foods', async (req, res) => {
  try {
    const category = req.query.category || 'all';
    const conn = await pool.getConnection();
    
    let query = 'SELECT id, name, category, price, discount, description FROM Food_Menu';
    let params = [];
    
    if (category !== 'all') {
      query += ' WHERE category = ?';
      params.push(category);
    }
    
    query += ' ORDER BY category, name';
    
    const [rows] = await conn.execute(query, params);
    conn.release();
    
    res.json({
      success: true,
      count: rows.length,
      data: rows
    });
  } catch (error) {
    console.error('Database error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch foods',
      message: error.message
    });
  }
});

// GET all unique categories
app.get('/api/categories', async (req, res) => {
  try {
    const conn = await pool.getConnection();
    const [rows] = await conn.execute('SELECT DISTINCT category FROM Food_Menu ORDER BY category');
    conn.release();
    
    const categories = rows.map(row => row.category);
    res.json({
      success: true,
      categories: categories
    });
  } catch (error) {
    console.error('Database error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch categories'
    });
  }
});

// GET single food item by ID
app.get('/api/foods/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const conn = await pool.getConnection();
    
    const [rows] = await conn.execute(
      'SELECT * FROM Food_Menu WHERE id = ?',
      [id]
    );
    conn.release();
    
    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Food item not found'
      });
    }
    
    res.json({
      success: true,
      data: rows[0]
    });
  } catch (error) {
    console.error('Database error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch food item'
    });
  }
});

// POST - Save order
app.post('/api/orders', async (req, res) => {
  let conn;
  try {
    const {
      items,
      subtotal,
      delivery,
      tax,
      grandTotal,
      customerName,
      customerPhone,
      deliveryAddress
    } = req.body;

    let authenticatedUserId = null;
    const token = getBearerToken(req);
    if (token) {
      try {
        const decoded = verifyToken(token);
        authenticatedUserId = decoded.userId || null;
      } catch (error) {
        return res.status(401).json({
          success: false,
          error: 'Invalid or expired token'
        });
      }
    }

    const normalizedCustomerName = String(customerName || '').trim() || 'Walk-in Customer';
    const normalizedCustomerPhone = String(customerPhone || '').trim() || 'N/A';
    const normalizedDeliveryAddress = String(deliveryAddress || '').trim() || 'Address not captured';
    
    if (!items || items.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Cart is empty'
      });
    }

    conn = await pool.getConnection();
    await conn.beginTransaction();
    
    // Insert order
    const [result] = await conn.execute(
      `INSERT INTO orders (user_id, items, subtotal, delivery, tax, grand_total, created_at)
       VALUES (?, ?, ?, ?, ?, ?, NOW())`,
      [authenticatedUserId, JSON.stringify(items), subtotal, delivery, tax, grandTotal]
    );

    const orderId = result.insertId;
    const receiptNumber = generateReceiptNumber(orderId);

    await conn.execute(
      `INSERT INTO Receipt (
        order_id,
        user_id,
        receipt_number,
        items,
        subtotal,
        delivery,
        tax,
        grand_total,
        customer_name,
        customer_phone,
        delivery_address,
        status,
        created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'generated', NOW())`,
      [
        orderId,
        authenticatedUserId,
        receiptNumber,
        JSON.stringify(items),
        subtotal,
        delivery,
        tax,
        grandTotal,
        normalizedCustomerName,
        normalizedCustomerPhone,
        normalizedDeliveryAddress
      ]
    );

    await conn.commit();
    
    conn.release();
    conn = null;
    
    res.json({
      success: true,
      orderId,
      receiptNumber,
      message: 'Order placed successfully',
      total: grandTotal
    });
  } catch (error) {
    if (conn) {
      await conn.rollback();
      conn.release();
    }

    console.error('Database error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to place order',
      message: error.message
    });
  }
});

app.get('/api/auth/me', requireAuth, async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection();
    const [rows] = await conn.execute(
      'SELECT id, username, email, created_at FROM users WHERE id = ? LIMIT 1',
      [req.authUser.userId]
    );
    conn.release();
    conn = null;

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'User not found'
      });
    }

    res.json({
      success: true,
      user: rows[0]
    });
  } catch (error) {
    if (conn) {
      conn.release();
    }
    console.error('Profile error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to load profile',
      message: error.message
    });
  }
});

app.get('/api/receipts/my', requireAuth, async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection();
    const [rows] = await conn.execute(
      `SELECT
        id,
        order_id,
        receipt_number,
        items,
        subtotal,
        delivery,
        tax,
        grand_total,
        customer_name,
        customer_phone,
        delivery_address,
        status,
        created_at
       FROM Receipt
       WHERE user_id = ?
       ORDER BY created_at DESC`,
      [req.authUser.userId]
    );
    conn.release();
    conn = null;

    const receipts = rows.map((row) => {
      let parsedItems = [];
      if (Array.isArray(row.items)) {
        parsedItems = row.items;
      } else if (typeof row.items === 'string') {
        try {
          parsedItems = JSON.parse(row.items);
        } catch (error) {
          parsedItems = [];
        }
      } else if (row.items && typeof row.items === 'object') {
        parsedItems = Array.isArray(row.items) ? row.items : [];
      }

      return {
        ...row,
        items: parsedItems
      };
    });

    res.json({
      success: true,
      count: receipts.length,
      receipts
    });
  } catch (error) {
    if (conn) {
      conn.release();
    }
    console.error('Receipts error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to load receipts',
      message: error.message
    });
  }
});

// POST - User signup
app.post('/api/auth/signup', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({
        success: false,
        error: 'Username, email and password are required'
      });
    }

    if (typeof password !== 'string' || password.length < 6) {
      return res.status(400).json({
        success: false,
        error: 'Password must be at least 6 characters'
      });
    }

    const conn = await pool.getConnection();
    const normalizedEmail = String(email).trim().toLowerCase();

    const [existing] = await conn.execute(
      'SELECT id FROM users WHERE email = ? LIMIT 1',
      [normalizedEmail]
    );

    if (existing.length > 0) {
      conn.release();
      return res.status(409).json({
        success: false,
        error: 'Email is already registered'
      });
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const [result] = await conn.execute(
      `INSERT INTO users (username, email, password_hash, created_at)
       VALUES (?, ?, ?, NOW())`,
      [String(username).trim(), normalizedEmail, passwordHash]
    );

    const user = {
      id: result.insertId,
      username: String(username).trim(),
      email: normalizedEmail
    };

    const token = createToken(user);
    conn.release();

    res.status(201).json({
      success: true,
      message: 'Signup successful',
      token,
      user
    });
  } catch (error) {
    console.error('Signup error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create account',
      message: error.message
    });
  }
});

// POST - User login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: 'Email and password are required'
      });
    }

    const conn = await pool.getConnection();
    const normalizedEmail = String(email).trim().toLowerCase();
    const [rows] = await conn.execute(
      'SELECT id, username, email, password_hash FROM users WHERE email = ? LIMIT 1',
      [normalizedEmail]
    );

    if (rows.length === 0) {
      conn.release();
      return res.status(401).json({
        success: false,
        error: 'Invalid credentials'
      });
    }

    const userRow = rows[0];
    const passwordOk = await bcrypt.compare(password, userRow.password_hash);

    if (!passwordOk) {
      conn.release();
      return res.status(401).json({
        success: false,
        error: 'Invalid credentials'
      });
    }

    const user = {
      id: userRow.id,
      username: userRow.username,
      email: userRow.email
    };
    const token = createToken(user);
    conn.release();

    res.json({
      success: true,
      message: 'Login successful',
      token,
      user
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to login',
      message: error.message
    });
  }
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'Foodie Orange API is running',
    timestamp: new Date().toISOString()
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found'
  });
});

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`🚀 Foodie Orange API running on http://localhost:${PORT}`);
  console.log(`📍 Database: food ordering system`);
});
