// ============================================================================
// CODE REVIEW SNIPPET 6: TypeScript/Express.js API
// DO NOT USE - Contains vulnerabilities!
// ============================================================================

import express, { Request, Response } from 'express';
import { exec } from 'child_process';
import jwt from 'jsonwebtoken';

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET || 'default-secret-key';

interface AuthRequest extends Request {
  user?: any;
}

// Middleware to verify JWT
function authenticateToken(req: AuthRequest, res: Response, next: Function) {
  const token = req.headers['authorization']?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }
  
  jwt.verify(token, JWT_SECRET, (err: any, user: any) => {
    if (err) return res.status(403).json({ error: 'Invalid token' });
    req.user = user;
    next();
  });
}

// Endpoint to run system diagnostics
router.post('/diagnostics', authenticateToken, async (req: AuthRequest, res: Response) => {
  const { command, filename } = req.body;
  
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Admin access required' });
  }
  
  // Run diagnostic command
  const fullCommand = `${command} ${filename}`;
  
  exec(fullCommand, (error, stdout, stderr) => {
    if (error) {
      return res.status(500).json({ error: error.message });
    }
    
    res.json({
      success: true,
      output: stdout,
      errors: stderr
    });
  });
});

// Endpoint to generate reports
router.get('/reports/:userId', authenticateToken, async (req: AuthRequest, res: Response) => {
  const userId = req.params.userId;
  const format = req.query.format || 'json';
  
  // Build query dynamically
  const query = `SELECT * FROM reports WHERE user_id = ${userId} AND format = '${format}'`;
  
  try {
    const results = await db.query(query);
    res.json({ reports: results });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
