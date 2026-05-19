from flask import Flask, jsonify
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from datetime import datetime

app = Flask(__name__)

# Database connection
def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=os.getenv('DB_HOST', 'localhost'),
            database=os.getenv('DB_NAME', 'myapp'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', 'password')
        )
        return conn
    except Exception as e:
        return None

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({"status": "healthy", "timestamp": datetime.utcnow().isoformat()}), 200

@app.route('/api/status', methods=['GET'])
def status():
    """Application status with database connectivity"""
    conn = get_db_connection()
    db_status = "connected" if conn else "disconnected"
    if conn:
        conn.close()
    
    return jsonify({
        "environment": os.getenv('ENVIRONMENT', 'unknown'),
        "app": "healthy",
        "database": db_status,
        "timestamp": datetime.utcnow().isoformat()
    }), 200

@app.route('/api/info', methods=['GET'])
def info():
    """Application information"""
    return jsonify({
        "name": "DevOps Portfolio App",
        "version": "1.0.0",
        "environment": os.getenv('ENVIRONMENT', 'development'),
        "region": os.getenv('AWS_REGION', 'us-east-2')
    }), 200

@app.route('/', methods=['GET'])
def index():
    """Root endpoint"""
    return jsonify({
        "message": "Welcome to DevOps Portfolio Application",
        "endpoints": {
            "/health": "Health check",
            "/api/status": "Application status",
            "/api/info": "Application info"
        }
    }), 200

if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))
    app.run(host='0.0.0.0', port=port, debug=False)