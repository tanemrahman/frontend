import { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [health, setHealth] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchHealth();
    const interval = setInterval(fetchHealth, 30000); // Refresh every 30 seconds
    return () => clearInterval(interval);
  }, []);

  const fetchHealth = async () => {
    try {
      const response = await axios.get('/api/health');
      setHealth(response.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching health:', error);
      setLoading(false);
    }
  };

  const generateTestLogs = async () => {
    try {
      await axios.get('/api/logs/test');
      alert('Test logs generated successfully!');
    } catch (error) {
      console.error('Error generating logs:', error);
    }
  };

  return (
    <div className="app">
      <header className="header">
        <h1>Module 6 - Monitoring Stack Dashboard</h1>
        <p>Full Stack Monitoring with Prometheus, Grafana, Node Exporter & Loki</p>
      </header>

      <main className="main-content">
        <div className="card">
          <h2>Application Status</h2>
          {loading ? (
            <p>Loading...</p>
          ) : health ? (
            <div className="health-info">
              <p><strong>Status:</strong> <span className="status healthy">{health.status}</span></p>
              <p><strong>Uptime:</strong> {Math.floor(health.uptime)} seconds</p>
              <p><strong>Timestamp:</strong> {new Date(health.timestamp).toLocaleString()}</p>
            </div>
          ) : (
            <p className="error">Unable to fetch health status</p>
          )}
        </div>

        <div className="card">
          <h2>Monitoring Endpoints</h2>
          <div className="endpoints">
            <div className="endpoint">
              <h3>Prometheus</h3>
              <a href="http://localhost:9090" target="_blank" rel="noopener noreferrer">
                http://localhost:9090
              </a>
            </div>
            <div className="endpoint">
              <h3>Grafana</h3>
              <a href="http://localhost:3001" target="_blank" rel="noopener noreferrer">
                http://localhost:3001
              </a>
            </div>
            <div className="endpoint">
              <h3>Metrics</h3>
              <a href="/api/metrics" target="_blank" rel="noopener noreferrer">
                /api/metrics
              </a>
            </div>
          </div>
        </div>

        <div className="card">
          <h2>Log Testing</h2>
          <p>Generate test logs to verify Loki integration</p>
          <button onClick={generateTestLogs} className="btn-primary">
            Generate Test Logs
          </button>
        </div>

        <div className="card">
          <h2>Architecture</h2>
          <div className="architecture">
            <div className="component">
              <h4>Frontend</h4>
              <p>React application served via Express</p>
            </div>
            <div className="component">
              <h4>Node Exporter</h4>
              <p>System metrics collection</p>
            </div>
            <div className="component">
              <h4>Prometheus</h4>
              <p>Time Series Database & Metrics Storage</p>
            </div>
            <div className="component">
              <h4>Grafana</h4>
              <p>Visualization & Dashboards</p>
            </div>
            <div className="component">
              <h4>Loki</h4>
              <p>Log Aggregation System</p>
            </div>
          </div>
        </div>
      </main>

      <footer className="footer">
        <p>Module 6 Assignment - Full Monitoring Stack</p>
      </footer>
    </div>
  );
}

export default App;

