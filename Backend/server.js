const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
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

// Test database connection
pool.getConnection().then(conn => {
  console.log('✅ Connected to MySQL database');
  conn.release();
}).catch(err => {
  console.error('❌ Database connection failed:', err.message);
});

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
  try {
    const { items, subtotal, delivery, tax, grandTotal } = req.body;
    
    if (!items || items.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Cart is empty'
      });
    }
    
    const conn = await pool.getConnection();
    
    // Insert order
    const [result] = await conn.execute(
      `INSERT INTO orders (items, subtotal, delivery, tax, grand_total, created_at)
       VALUES (?, ?, ?, ?, ?, NOW())`,
      [JSON.stringify(items), subtotal, delivery, tax, grandTotal]
    );
    
    conn.release();
    
    res.json({
      success: true,
      orderId: result.insertId,
      message: 'Order placed successfully',
      total: grandTotal
    });
  } catch (error) {
    console.error('Database error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to place order',
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
