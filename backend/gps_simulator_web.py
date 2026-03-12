"""
GPS Simulator with HTTP health check endpoint for Render web service
"""
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler
import gps_simulator

class HealthCheckHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/' or self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'GPS Simulator is running')
        else:
            self.send_response(404)
            self.end_headers()
    
    def log_message(self, format, *args):
        # Suppress HTTP logs
        pass

def run_health_server():
    """Run health check server on port 10000 (Render's default)"""
    server = HTTPServer(('0.0.0.0', 10000), HealthCheckHandler)
    print("Health check server running on port 10000")
    server.serve_forever()

if __name__ == "__main__":
    # Start health check server in background thread
    health_thread = threading.Thread(target=run_health_server, daemon=True)
    health_thread.start()
    
    # Run GPS simulator (this is the main process)
    print("Starting GPS Simulator...")
    # Import and run the main GPS simulator code
    import sys
    import os
    sys.path.insert(0, os.path.dirname(__file__))
    
    # Run the original GPS simulator
    exec(open('gps_simulator.py').read())
