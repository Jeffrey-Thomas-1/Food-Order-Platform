# Foodie Orange Pro - Food Ordering System

A full-stack food ordering application with a React/Vanilla JS frontend and Node.js/Express backend.

---

## ⚡ QUICK START (One Command)

### **Windows - Double-Click to Start Everything**

Simply **double-click** this file in Windows Explorer:
```
Start-Servers.bat
```

✅ This will automatically:
1. Start Backend API (port 5000)
2. Start Frontend Server (port 8000)
3. Open browser to http://localhost:8000

**That's it!** Everything runs in the background. 🚀

---

### **Alternative - PowerShell (More Control)**

```powershell
PowerShell -ExecutionPolicy Bypass -File Start-Servers.ps1
```

Or run from PowerShell terminal in the project root:
```powershell
.\Start-Servers.ps1
```

---

## Project Structure

```
Team-Project-Shi/
├── Frontend/
│   ├── public/
│   │   └── index.html          # Main web app (uses API endpoints)
│   └── src/
│       └── Styles/
│           └── Styles.css      # Orange theme styling
├── Backend/
│   ├── server.js               # Express API server
│   ├── package.json            # Node dependencies
│   ├── .env.example            # Environment variables template
│   └── database/
│       └── schema.sql          # MySQL schema & sample data
└── Frontendtroubleshoot.html   # Standalone/testing version
```

## System Architecture

### Frontend
- **Technology**: Vanilla JavaScript + HTML + CSS
- **Features**:
  - Dynamic food menu (fetched from backend API)
  - Search & category filtering
  - Shopping cart with local storage
  - Order placement with API integration
  - Responsive mobile design
  - Orange theme (#fc8019 primary color)

### Backend
- **Technology**: Node.js + Express + MySQL
- **API Endpoints**:
  - `GET /api/foods` - Fetch all foods
  - `GET /api/foods?category=Indian` - Filter by category
  - `GET /api/categories` - Get all categories
  - `GET /api/foods/:id` - Get single food item
  - `POST /api/orders` - Place new order
  - `GET /api/health` - Health check

### Database
- **Type**: MySQL
- **Tables**:
  - `Food_Menu` - 52 food items with pricing & discounts
  - `orders` - Stores placed orders with JSON items

## Setup Instructions

### 1. Database Setup

```powershell
# Connect to MySQL
mysql -u root -p

# Run schema file
source Backend/database/schema.sql
```

Expected output:
- Database `database` created
- Tables `Food_Menu` (52 items) and `orders` created

### 2. Backend Setup

```powershell
cd Backend

# Install dependencies
npm install

# Start server
npm start
```

Expected output:
```
✅ Connected to MySQL database
🚀 Foodie Orange API running on http://localhost:5000
```

### 3. Frontend Setup

Open in browser:
```
file:///C:/Users/jeffr/Desktop/Jeffrey%20Clg/Team-Project-Shi/Frontend/public/index.html
```

Or with a simple HTTP server:
```powershell
cd Frontend/public
python -m http.server 8000
# Then visit http://localhost:8000
```

## Data Flow

### Getting Food Items
```
Frontend (index.html)
  ↓ fetch('/api/foods')
Backend (server.js)
  ↓ SELECT * FROM Food_Menu
MySQL Database
```

### Placing Order
```
Frontend (index.html)
  ↓ POST /api/orders
Backend (server.js)
  ↓ INSERT INTO orders
MySQL Database
```

## Database Compatibility

### Frontend Table Names vs Database
| Component | Frontend | Database |
|-----------|----------|----------|
| Categories | Indian, Chinese, Italian, FastFood, Dessert, Beverage | ✅ Matches |
| Prices | ₹120-320 | ✅ Matches |
| Discounts | 10-30% | ✅ Now supported (was missing) |
| Data Source | API calls | ✅ MySQL queries |
| Items Count | Dynamic (52 from DB) | ✅ 52 seeded items |

### Fixed Issues
1. ✅ **Added discount field** to Food_Menu table
2. ✅ **Updated categories** to match frontend dropdown
3. ✅ **Updated prices** to match frontend price range
4. ✅ **Created backend API** to serve database data
5. ✅ **Updated frontend** to use API instead of hardcoded data
6. ✅ **Added order storage** via `orders` table

## Environment Configuration (.env File)

### What is .env?
- `.env` is a configuration file that stores **sensitive credentials** (passwords, API keys, database settings)
- **NEVER** commit `.env` to Git (it's in `.gitignore`)
- Each team member creates their **own local `.env`** with their credentials
- No conflicts: file is local to each developer's machine

### First Time Setup (Create .env)

**From Backend folder:**

```powershell
cd "C:\Users\jeffr\Desktop\Jeffrey Clg\Team-Project-Shi\Backend"
copy .env.example .env
```

**Edit the `.env` file (paste your MySQL password):**

```powershell
notepad .env
```

**Default `.env` contents** (if MySQL password is `Root123@`):
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=Root123@
DB_NAME=database
PORT=5000
NODE_ENV=development
```

**Key Variables Explained:**
- `DB_HOST` - Where MySQL server is running (localhost = your machine, or IP address for remote)
- `DB_USER` - MySQL username (usually `root`)
- `DB_PASSWORD` - Your MySQL root password
- `DB_NAME` - Database name (must be `database`)
- `PORT` - Express server port (5000 is standard)
- `NODE_ENV` - Environment type (`development` for testing, `production` for live)

**Save and close Notepad** (Ctrl+S, then close window).

### Team Member Setup (.env for Different Systems)

Each developer's `.env` is **different** and **stays on their machine only**:

**Developer 1 (Local MySQL password: `pass123`):**
```
DB_PASSWORD=pass123
DB_HOST=localhost
```

**Developer 2 (Remote MySQL at 192.168.1.100, password: `SecurePass2026`):**
```
DB_PASSWORD=SecurePass2026
DB_HOST=192.168.1.100
```

**Developer 3 (No MySQL password, localhost):**
```
DB_PASSWORD=
DB_HOST=localhost
```

Each file is **local** and **private** - never pushed to Git. No conflicts! ✅

---

## Starting the Backend Server (Node.js / npm)

### Prerequisites
- **Node.js installed** - Check: `node --version` (should show version like v18.x.x)
- **npm installed** - Check: `npm --version` (should show version like 9.x.x)
- **MySQL running** - Check: MySQL service is active in Windows Services
- **`.env` file created** - Must have credentials configured

### Step 1: Verify Node and npm

```powershell
node --version
npm --version
```

**If command not found**, install Node.js:
- Download: https://nodejs.org (LTS version)
- Or via PowerShell (admin): `winget install OpenJS.NodeJS.LTS`

### Step 2: Navigate to Backend

```powershell
cd "C:\Users\jeffr\Desktop\Jeffrey Clg\Team-Project-Shi\Backend"
```

**Verify you're in correct folder:**
```powershell
pwd
# Should show: C:\Users\...\Backend
```

### Step 3: Install Dependencies (First Time Only)

```powershell
npm install
```

**What it does**: Downloads all required packages (express, mysql2, cors, dotenv) into `node_modules/` folder

**Expected output:**
```
up to date, audited 65 packages
```

### Step 4: Start the Server

```powershell
npm start
```

**Expected SUCCESS output:**
```
✅ Connected to MySQL database
🚀 Foodie Orange API running on http://localhost:5000
```

**If ERROR** - Common fixes:

| Error | Fix |
|-------|-----|
| `Cannot find module 'express'` | Run `npm install` again |
| `Database connection failed` | Check `.env` has correct password and MySQL is running |
| `Port 5000 already in use` | Another app uses port 5000. Either close it or change PORT in `.env` |
| `npm: command not found` | Node.js not installed, restart PowerShell after installing |

### Step 5: Verify Server is Running

**Option A: Test API (in new PowerShell window):**
```powershell
curl -UseBasicParsing http://localhost:5000/api/health
```

**Expected response:**
```json
{"success":true,"message":"Foodie Orange API is running"...}
```

**Option B: Open in browser:**
```
http://localhost:5000/api/health
```

Should display JSON response visually.

### Step 6: Stop the Server

**In the PowerShell running `npm start`**, press: **`Ctrl+C`**

```
^C
```

Server stops and prompt returns.

---

## Complete Development Workflow

### Every Development Session

**Terminal 1 - Backend:**
```powershell
cd Backend
npm start
```
Keep this running (don't close the window).

**Terminal 2 - Frontend:**
```powershell
cd Frontend\public
python -m http.server 8000
```
Keep this running (don't close the window).

**Browser:**
```
http://localhost:8000
```

### To Stop

- **Backend**: Press `Ctrl+C` in Terminal 1
- **Frontend**: Press `Ctrl+C` in Terminal 2
- **MySQL**: Runs as service (no action needed unless restarting computer)

---

## 🤝 Team Setup & Troubleshooting Guide

This section covers common issues team members face during setup and development. **Read this if you're stuck!**

---

### **I. FIRST TIME SETUP (For Each Team Member)**

#### **Step 1: Clone/Get Project**

```powershell
# If using Git:
git clone <repository-url>
cd Team-Project-Shi

# OR if you already have it:
cd "C:\Users\YOUR_NAME\Desktop\Jeffrey Clg\Team-Project-Shi"
```

#### **Step 2: Check Node.js is Installed**

**Run this command:**
```powershell
node --version
npm --version
```

**Expected output:**
```
v18.17.1
9.8.3
```

**If not found** (says "command not found"):
- Download: https://nodejs.org (LTS version)
- Install it
- **Restart PowerShell** (close and reopen)
- Try the version commands again

#### **Step 3: Check MySQL is Running**

**Run this command:**
```powershell
Get-Service MySQL80 | Select-Object Status
```

**Expected output:**
```
Status
------
Running
```

**If it says "Stopped"**:
- Open Windows Services (Services.msc)
- Find "MySQL80"
- Right-click → Start

#### **Step 4: Create Your Local .env File**

**In Backend folder:**
```powershell
cd Backend
copy .env.example .env
notepad .env
```

**Edit the password** (ask a team member for the MySQL root password):
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=Root123@        ← REPLACE with actual password
DB_NAME=database
PORT=5000
NODE_ENV=development
```

**Save and close Notepad** (Ctrl+S, then close).

**IMPORTANT**: `.env` is in `.gitignore` - it will NOT be pushed to Git, so each team member has their own.

#### **Step 5: Install Dependencies**

```powershell
# Stay in Backend folder
npm install
```

**Wait for it to finish** (~30 seconds). You should see:
```
up to date, audited 65 packages
```

#### **Step 6: Verify Database Schema**

**In new PowerShell:**
```powershell
mysql -h localhost -u root -p"YOUR_PASSWORD" -e "USE database; SELECT COUNT(*) FROM Food_Menu;"
```

**Expected output** (shows count of food items):
```
+----------+
| COUNT(*) |
+----------+
|       52 |
+----------+
```

**If this fails**, check:
1. MySQL is running (Step 3)
2. Password is correct
3. The file `Backend/database/schema.sql` was imported

---

### **II. STARTING THE PROJECT (Every Time)**

#### **Easiest Way – One Command**

```powershell
cd "C:\Users\YOUR_NAME\Desktop\Jeffrey Clg\Team-Project-Shi"
.\Start-Servers.bat
```

**This will automatically:**
- ✅ Start backend on port 5000
- ✅ Start frontend on port 8000
- ✅ Open browser to http://localhost:8000

#### **Manual Way (If Script Fails)**

**Terminal 1 - Backend:**
```powershell
cd Backend
npm start
```

**Terminal 2 - Frontend (new PowerShell window):**
```powershell
cd Frontend\public
python -m http.server 8000
```

**Both should show success messages** (backend: "🚀 API running on port 5000", frontend: "Serving HTTP on...")

---

### **III. COMMON PROBLEMS & SOLUTIONS**

#### **Problem 1: "npm: command not found"**

**Cause**: Node.js not installed or PATH not updated

**Solution**:
1. Install Node.js: https://nodejs.org (LTS)
2. During installation, make sure **"Add to PATH"** is checked
3. **Restart PowerShell completely** (close and reopen)
4. Try `npm --version` again

---

#### **Problem 2: "Unable to load menu" Error on Website**

**Cause**: Backend API server not running

**Solution**:
1. Open http://localhost:5000/api/health in browser
2. If it shows error/blank → Backend not running
3. Start backend: Go to Backend folder and run `npm start`
4. Refresh the food ordering site (Ctrl+F5)

---

#### **Problem 3: CSS Not Styling (No Orange Theme)**

**Cause**: Frontend served from wrong directory or CSS path wrong

**Solution**: Use the batch script:
```powershell
.\Start-Servers.bat
```

Or manually ensure you're running Python server **from** `Frontend/public/` folder:
```powershell
cd Frontend\public
python -m http.server 8000
```

---

#### **Problem 4: "Access denied for user 'root'" Database Error**

**Cause**: MySQL password in `.env` is wrong

**Solution**:
1. Check your `.env` file has correct password
2. Verify password in MySQL itself (ask team)
3. Make sure MySQL service is running

---

#### **Problem 5: "Port 5000 Already in Use"**

**Cause**: Another application using port 5000

**Solution**:
- Find which app: `netstat -ano | findstr :5000`
- Either close that app OR change PORT in `.env` to 5001
- If you change it, also update `Frontend/public/index.html` line 44:
  ```javascript
  const API_URL = 'http://localhost:5001/api';  // Changed from 5000
  ```

---

#### **Problem 6: "Cannot find module 'express'" Error**

**Cause**: `node_modules` not installed

**Solution**:
```powershell
cd Backend
npm install
```

---

#### **Problem 7: Website Shows But Database Items Don't Load**

**Cause**: Database schema not imported or food items missing

**Solution**:
```powershell
mysql -h localhost -u root -p
# Enter password when prompted

# Then in MySQL prompt:
source C:/Users/YOUR_NAME/Desktop/Jeffrey\ Clg/Team-Project-Shi/Backend/database/schema.sql;
```

Check items were imported:
```sql
SELECT COUNT(*) FROM Food_Menu;
```

Should show: 52 items

---

#### **Problem 8: Search or Category Filter Not Working**

**Cause**: API not responding or JavaScript error

**Solution**:
1. Open browser Developer Tools (F12)
2. Click **Console** tab
3. Look for red error messages
4. Common fix: Restart backend (`npm start`)
5. Refresh browser (Ctrl+F5)

---

### **IV. TEAM COLLABORATION DO's AND DON'Ts**

#### ✅ **DO:**
- ✅ Commit changes to HTML, CSS, JavaScript files
- ✅ Commit `package.json` and `package-lock.json`
- ✅ Commit `.env.example` (template)
- ✅ Commit `Backend/database/schema.sql`
- ✅ Commit `README.md` with setup instructions

#### ❌ **DON'T:**
- ❌ Commit `.env` file (contains passwords!) - it's in `.gitignore`
- ❌ Commit `node_modules/` folder (too large, auto-generated)
- ❌ Commit `DB_verification.env` (test file)

#### **When Pulling Changes:**

After team member pushes code:
```powershell
git pull
npm install  # In case Backend dependencies changed
```

Then start normally:
```powershell
.\Start-Servers.bat
```

---

### **V. DEBUGGING TIPS FOR DEVELOPERS**

#### **Check Backend Logs**

Backend terminal shows API errors. Watch for:
- **Red "❌" messages** = Database connection issues
- **"Error" in console** = Query or API errors
- **No output** = Server might be stuck

Solution: Press Ctrl+C to stop, then `npm start` to restart

#### **Check Browser Console**

Press F12 in browser → Console tab. Watch for:
- **Red errors** = JavaScript errors
- **Network errors** = API not responding
- **CORS errors** = Backend not allowing requests

#### **Check Database**

Verify data in MySQL:
```powershell
mysql -u root -p
USE database;
SELECT * FROM Food_Menu LIMIT 5;
SELECT * FROM orders;
```

---

### **VI. PERFORMANCE TIPS**

| Tip | Benefit |
|-----|---------|
| Close other browser tabs | Faster development |
| Use Ctrl+F5 (hard refresh) instead of F5 | Clears cache, loads fresh |
| Keep backend terminal visible | Easier to spot errors |
| Use VS Code for editing | Better syntax highlighting |
| Restart servers if behavior odd | Clears in-memory state |

---

### **VII. GETTING HELP**

**If stuck, check in this order:**

1. **Browser console** (F12 → Console) - Shows JavaScript errors
2. **Backend terminal** - Shows API and database errors  
3. **This README** - Check "Common Problems" section
4. **Ask team member** - Share error messages
5. **Re-run setup** - Sometimes fresh install fixes issues

---

### **VIII. QUICK REFERENCE COMMANDS**

```powershell
# Start everything (BEST)
.\Start-Servers.bat

# Start just backend
cd Backend && npm start

# Start just frontend
cd Frontend\public && python -m http.server 8000

# Check services
Get-Service MySQL80

# Test API
curl -UseBasicParsing http://localhost:5000/api/health

# Test database
mysql -u root -p -e "SELECT COUNT(*) FROM database.Food_Menu;"

# Stop a server
Ctrl+C (in the terminal running it)

# Clear npm cache (if install fails)
npm cache clean --force

# Reinstall dependencies
rm -r node_modules package-lock.json
npm install
```

---

## Summary

**Current Project Status**: ✅ Fully functional full-stack application

| Component | Status | Details |
|-----------|--------|---------|
| Frontend | ✅ Ready | Vanilla JS + CSS, loads from API |
| Backend | ✅ Ready | Express server with 6 endpoints |
| Database | ✅ Ready | MySQL with 52 food items |
| Startup | ✅ Ready | One-click batch script |
| Documentation | ✅ Complete | Setup guide for team members |

**To get started:** Just run `.\Start-Servers.bat` and the entire system launches automatically!
