# Module 6 Assignment - Submission Guide (বাংলা)

## 📋 Submission করার জন্য Step-by-Step Guide

### Step 1: সব Screenshot নিন

#### Part 1: Frontend Deployment

1. **Node.js Installation Screenshot:**
   - Terminal খুলুন
   - `node --version` লিখুন
   - Screenshot নিন (Windows: `Win + Shift + S`)

2. **Frontend Build Screenshot:**
   - `cd frontend`
   - `npm install` run করুন
   - `npm run build` run করুন
   - Screenshot নিন

3. **Frontend Browser Screenshot:**
   - Browser এ `http://localhost:3000` open করুন
   - Full page screenshot নিন

#### Part 2: Monitoring Stack

1. **Prometheus Screenshot:**
   - `http://localhost:9090` open করুন
   - Targets page screenshot নিন
   - Configuration file screenshot নিন

2. **Grafana Screenshot:**
   - `http://localhost:3001` open করুন
   - Login page screenshot
   - Dashboard screenshot
   - Datasources screenshot

3. **Node Exporter Screenshot:**
   - `http://localhost:9100/metrics` open করুন
   - Screenshot নিন

#### Part 3: Log Configuration

1. **Winston-Loki Config:**
   - `server.js` file open করুন
   - Winston-Loki configuration part screenshot

2. **Prometheus Log Metrics:**
   - Prometheus এ log-based metrics query করুন
   - Screenshot নিন

3. **Grafana Log Panel:**
   - Grafana Explore এ log query করুন
   - Screenshot নিন

#### Part 4: TSDB Concepts

1. **Prometheus Queries:**
   - Prometheus UI এ বিভিন্ন PromQL query run করুন
   - Screenshot নিন

#### Part 5: Loki & SIEM

1. **Loki Installation:**
   - Loki running status screenshot

2. **Loki in Grafana:**
   - Grafana এ Loki datasource screenshot
   - Log stream screenshot

---

### Step 2: Documentation তৈরি করুন

#### Option 1: Word Document ব্যবহার করুন

1. Microsoft Word খুলুন
2. `docs/SUBMISSION_TEMPLATE.md` file টা open করুন
3. প্রতিটি section এ:
   - Step-by-step explanation লিখুন
   - Screenshot insert করুন
   - Code snippets add করুন

#### Option 2: Markdown + Images

1. `docs/SUBMISSION_TEMPLATE.md` copy করুন
2. Screenshot গুলো `screenshots/` folder এ রাখুন
3. Markdown file এ screenshot reference add করুন

---

### Step 3: Screenshot Organize করুন

একটা folder structure তৈরি করুন:

```
submission/
├── screenshots/
│   ├── part1_frontend/
│   ├── part2_monitoring/
│   ├── part3_logs/
│   ├── part4_tsdb/
│   └── part5_loki/
├── documentation/
│   └── SUBMISSION.md
└── code/
    └── (configuration files)
```

---

### Step 4: প্রতিটি Part এর জন্য কি কি লাগবে

#### Part 1: Frontend Deployment ✅

**Screenshots:**
- [ ] Node.js version
- [ ] npm install output
- [ ] npm run build output
- [ ] Frontend in browser
- [ ] Health endpoint response

**Documentation:**
- Server environment setup steps
- Frontend build process
- How application is served
- Verification steps

---

#### Part 2: Monitoring Stack ✅

**Screenshots:**
- [ ] Prometheus installation
- [ ] Prometheus UI (http://localhost:9090)
- [ ] Prometheus targets (all UP)
- [ ] Grafana login page
- [ ] Grafana datasources
- [ ] Node Exporter metrics
- [ ] Node Exporter dashboard
- [ ] Application metrics dashboard
- [ ] Security group/firewall config (if cloud)

**Documentation:**
- Prometheus installation steps
- Grafana installation steps
- Node Exporter setup
- Configuration details
- Security configuration
- Dashboard creation

---

#### Part 3: Log Configuration ✅

**Screenshots:**
- [ ] Winston-Loki configuration code
- [ ] Prometheus showing log metrics
- [ ] Grafana log metrics panel
- [ ] Log query examples

**Documentation:**
- How logs are exported
- Log-to-metrics conversion
- Validation steps

---

#### Part 4: TSDB Concepts ✅

**Screenshots:**
- [ ] Prometheus storage info
- [ ] PromQL query examples
- [ ] Time-series graphs

**Documentation:**
- What is TSDB? (explanation)
- How Prometheus stores data
- PromQL examples
- Comparison table (Prometheus vs others)
- Monitoring architectures explanation

---

#### Part 5: Loki & SIEM ✅

**Screenshots:**
- [ ] Loki installation
- [ ] Loki configuration
- [ ] Loki datasource in Grafana
- [ ] Log stream in Grafana
- [ ] LogQL queries
- [ ] Log visualizations

**Documentation:**
- Loki installation steps
- Log forwarding configuration
- SIEM explanation
- APM explanation
- Loki vs ELK comparison

---

### Step 5: Final Document তৈরি করুন

#### Word Document Format:

1. **Cover Page:**
   - Assignment Title
   - Your Name
   - Student ID
   - Date

2. **Table of Contents**

3. **Part 1-5:** প্রতিটি part এর জন্য:
   - Introduction
   - Steps taken
   - Screenshots
   - Explanations
   - Verification

4. **Summary & Conclusion**

5. **References**

---

### Step 6: Quality Check

Submission করার আগে check করুন:

- [ ] সব 5 parts covered হয়েছে
- [ ] সব required screenshots আছে
- [ ] Screenshots clear এবং readable
- [ ] সব explanations আছে
- [ ] Comparison tables আছে
- [ ] Code examples explained
- [ ] No placeholder text
- [ ] Document well-formatted
- [ ] Spelling/grammar checked

---

## 🎯 Quick Checklist

### Screenshots Needed (Minimum):

1. ✅ Frontend running in browser
2. ✅ Prometheus UI with targets
3. ✅ Grafana dashboard
4. ✅ Node Exporter metrics
5. ✅ Loki datasource in Grafana
6. ✅ Log stream in Grafana
7. ✅ Prometheus queries
8. ✅ Configuration files

### Documentation Needed:

1. ✅ Installation steps for each component
2. ✅ Configuration explanations
3. ✅ TSDB explanation
4. ✅ SIEM explanation
5. ✅ APM explanation
6. ✅ Comparison tables
7. ✅ Architecture diagrams

---

## 💡 Tips

1. **Screenshot Quality:**
   - High resolution use করুন
   - Unnecessary parts crop করুন
   - Labels add করুন যদি needed

2. **Documentation:**
   - Step-by-step লিখুন
   - WHY explain করুন, শুধু WHAT নয়
   - Code snippets explain করুন

3. **Organization:**
   - Clear headings use করুন
   - Numbered steps
   - Tables for comparisons
   - Consistent formatting

---

## 📝 Sample Screenshot Descriptions

### Example 1: Prometheus Targets

**Screenshot Description:**
"This screenshot shows the Prometheus targets page (http://localhost:9090/targets). All three targets are showing as UP:
1. prometheus (self-monitoring) - localhost:9090
2. node-exporter (system metrics) - localhost:9100  
3. nodejs-app (application metrics) - localhost:3000/api/metrics

This confirms that Prometheus is successfully scraping metrics from all configured targets."

### Example 2: Grafana Dashboard

**Screenshot Description:**
"This screenshot shows the Node Exporter dashboard in Grafana. The dashboard displays:
- CPU usage over time (line graph)
- Memory usage percentage (gauge)
- Disk I/O rates (time series)
- Network traffic (time series)

All panels are showing real-time data from Prometheus, confirming successful metric ingestion."

---

## 🚀 Ready to Submit?

এখন আপনি:

1. ✅ সব screenshots নিয়েছেন
2. ✅ Documentation তৈরি করেছেন
3. ✅ সব explanations add করেছেন
4. ✅ Final document review করেছেন

**Submission করুন!** 🎉

---

## 📧 Submission Format

- **PDF** (recommended) - Single comprehensive PDF
- **Word Document** - With embedded images
- **Markdown + Images** - GitHub repository
- **HTML** - Interactive document

File name: `Module6_Assignment_[YourName]_[Date].pdf`

---

Good luck! 💪

