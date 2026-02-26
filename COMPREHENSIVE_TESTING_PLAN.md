# Comprehensive Testing Plan - Supply Chain Tracker

## 🎯 Testing Objectives

1. Verify all Docker services start correctly
2. Test database connectivity and schema
3. Validate API endpoints
4. Check real-time WebSocket connections
5. Test GPS simulator data generation
6. Verify Pathway pipeline ETA calculations
7. Test AI Alert Service
8. Validate RAG Chatbot
9. Test React Dashboard functionality
10. Verify Driver Safety Monitor (webcam)

---

## 📋 Pre-Testing Checklist

Before starting tests:
- [ ] `.env` file exists with GROQ_API_KEY
- [ ] Docker Desktop is running
- [ ] No other services using ports 3000, 5432, 8000, 8001, 8100
- [ ] Webcam available for driver safety testing
- [ ] Node.js installed (for React dashboard)

---

## 🚀 Phase 1: Clean Start

### Step 1.1: Stop All Services
```bash
cd supply-chain-tracker
docker-compose down -v
```
**Expected**: All containers stopped, volumes removed

### Step 1.2: Clean Docker System (Optional)
```bash
docker system prune -f
```
**Expected**: Cleanup completed

### Step 1.3: Verify Environment Variables
```bash
# Windows
type .env

# Check for GROQ_API_KEY
```
**Expected**: Should see `GROQ_API_KEY=gsk_...`

---

## 🐳 Phase 2: Docker Services Testing

### Step 2.1: Build All Services
```bash
docker-compose build --no-cache
```
**Expected**: 
- ✅ All services build successfully
- ✅ No build errors
- ⏱️ Takes 5-10 minutes

**Check for**:
- postgres (uses image, no build)
- gps-simulator (builds)
- pathway-pipeline (builds)
- backend-api (builds)
- chatbot (builds)
- ai-alert-service (builds)
- driver-safety (builds)

### Step 2.2: Start All Services
```bash
docker-compose up -d
```
**Expected**:
- ✅ All containers start
- ✅ No immediate crashes

### Step 2.3: Check Service Status
```bash
docker-compose ps
```
**Expected Output**:
```
NAME                  STATUS
ai_alert_service      Up
backend_api           Up
chatbot               Up
driver_safety         Up
gps_simulator         Up
pathway_pipeline      Up
postgres              Up (healthy)
```

**If any service shows "Exit" or "Restarting"**:
```bash
docker logs [service_name]
```

### Step 2.4: Check Service Logs
```bash
# Check each service for errors
docker logs postgres --tail 20
docker logs backend_api --tail 20
docker logs gps_simulator --tail 20
docker logs pathway_pipeline --tail 20
docker logs chatbot --tail 20
docker logs ai_alert_service --tail 20
docker logs driver_safety --tail 20
```

**Expected**:
- ✅ No error messages
- ✅ Services show "started" or "running"
- ✅ Database shows "ready to accept connections"

---

## 💾 Phase 3: Database Testing

### Step 3.1: Connect to Database
```bash
docker exec -it postgres psql -U supply_chain_user -d supply_chain_db
```
**Expected**: PostgreSQL prompt appears

### Step 3.2: Verify Tables
```sql
\dt
```
**Expected Tables**:
- shipments
- telemetry
- alerts
- eta_history
- shipment_events

### Step 3.3: Check Sample Data
```sql
-- Check shipments
SELECT * FROM shipments;

-- Should show SH001 and SH002
```
**Expected**: 2 shipments (SH001, SH002)

### Step 3.4: Check Telemetry Data (Wait 30 seconds first)
```sql
SELECT COUNT(*) FROM telemetry;
```
**Expected**: Growing number (30+ records after 1 minute)

### Step 3.5: Check ETA History
```sql
SELECT COUNT(*) FROM eta_history;
```
**Expected**: Growing number (10+ records after 1 minute)

### Step 3.6: Exit Database
```sql
\q
```

---

## 🔌 Phase 4: Backend API Testing

### Step 4.1: Health Check
```bash
curl http://localhost:8000/health
```
**Expected**:
```json
{"status": "healthy", "database": "connected"}
```

### Step 4.2: API Documentation
Open browser: http://localhost:8000/docs

**Expected**:
- ✅ Swagger UI loads
- ✅ Shows all endpoints
- ✅ Can expand and see details

### Step 4.3: Test Statistics Endpoint
```bash
curl http://localhost:8000/api/stats
```
**Expected**:
```json
{
  "total_shipments": 2,
  "active_alerts": 0,
  "avg_fleet_speed_kmph": 45.5,
  "total_telemetry_records": 150,
  "timestamp": "2026-02-..."
}
```

### Step 4.4: Test Shipments Endpoint
```bash
curl http://localhost:8000/api/shipments
```
**Expected**: Array with 2 shipments (SH001, SH002)

### Step 4.5: Test Telemetry Endpoint
```bash
curl http://localhost:8000/api/telemetry?limit=5
```
**Expected**: Array with 5 recent GPS records

### Step 4.6: Test Latest Telemetry
```bash
curl http://localhost:8000/api/telemetry/latest/SH001
```
**Expected**: Single GPS record for SH001

---

## 🤖 Phase 5: RAG Chatbot Testing

### Step 5.1: Health Check
```bash
curl http://localhost:8001/health
```
**Expected**:
```json
{"status": "healthy", "groq_configured": true}
```

### Step 5.2: Test Chat Endpoint
```bash
curl -X POST http://localhost:8001/chat ^
  -H "Content-Type: application/json" ^
  -d "{\"query\": \"What is the status of SH001?\"}"
```
**Expected**:
```json
{
  "answer": "Shipment SH001 is currently...",
  "sources": ["shipments_table", "telemetry_table"]
}
```

### Step 5.3: Test Another Query
```bash
curl -X POST http://localhost:8001/chat ^
  -H "Content-Type: application/json" ^
  -d "{\"query\": \"How many shipments are active?\"}"
```
**Expected**: AI response with shipment count

---

## 🚨 Phase 6: AI Alert Service Testing

### Step 6.1: Health Check
```bash
curl http://localhost:8100/health/db
```
**Expected**:
```json
{"db": "ok", "value": 1}
```

### Step 6.2: Test Stall Detection
```bash
curl -X POST http://localhost:8100/alerts/check-stall ^
  -H "Content-Type: application/json" ^
  -d "{\"stall_minutes\": 5, \"speed_threshold_kmph\": 5, \"max_move_meters\": 100}"
```
**Expected**:
```json
{"created_alerts": []}
```
(Empty if no shipments are stalled)

### Step 6.3: Check API Documentation
Open browser: http://localhost:8100/docs

**Expected**: Swagger UI with alert endpoints

---

## 📡 Phase 7: GPS Simulator Testing

### Step 7.1: Check Logs
```bash
docker logs gps_simulator --tail 50
```
**Expected**:
```
🚀 Starting GPS Simulator...
🚛 SH001: Mumbai → Delhi
🟢 SH001: (19.0761, 72.8776) @ 40.3 km/h
🟢 SH001: (19.1234, 72.9876) @ 55.2 km/h
```

### Step 7.2: Verify Data in Database
```bash
docker exec -it postgres psql -U supply_chain_user -d supply_chain_db -c "SELECT shipment_id, lat, lon, speed_kmph, ts FROM telemetry ORDER BY ts DESC LIMIT 10;"
```
**Expected**: Recent GPS records with timestamps

### Step 7.3: Check Update Frequency
Wait 10 seconds and run again - should see new records

---

## 🛣️ Phase 8: Pathway Pipeline Testing

### Step 8.1: Check Logs
```bash
docker logs pathway_pipeline --tail 50
```
**Expected**:
```
🚀 PATHWAY PIPELINE - ETA CALCULATION
📡 Reading GPS telemetry...
🔴 SH001: 1138.5km away | Speed: 40.3km/h | ETA: 1708min | Confidence: 85%
```

### Step 8.2: Verify ETA Data in Database
```bash
docker exec -it postgres psql -U supply_chain_user -d supply_chain_db -c "SELECT shipment_id, distance_remaining_km, confidence, computed_at FROM eta_history ORDER BY computed_at DESC LIMIT 10;"
```
**Expected**: ETA predictions with distances and confidence scores

### Step 8.3: Check CSV Output
```bash
docker exec -it pathway_pipeline cat /app/outputs/eta_predictions.csv
```
**Expected**: CSV file with ETA predictions

---

## 🎨 Phase 9: React Dashboard Testing

### Step 9.1: Install Dependencies
```bash
cd supply-chain-dashboard
npm install
```
**Expected**: Dependencies installed successfully

### Step 9.2: Check Environment Variables
```bash
type .env
```
**Expected**:
```
VITE_API_URL=http://localhost:8000
VITE_RAG_API_URL=http://localhost:8001
VITE_MAPBOX_TOKEN=your_token_here
```

### Step 9.3: Start Development Server
```bash
npm run dev
```
**Expected**:
```
VITE v7.x.x ready in xxx ms
➜  Local:   http://localhost:3000/
```

### Step 9.4: Open Dashboard
Open browser: http://localhost:3000

**Expected**:
- ✅ Dashboard loads without errors
- ✅ Sidebar visible with navigation
- ✅ KPI cards show data
- ✅ No console errors

### Step 9.5: Test Navigation
Click through all pages:
- [ ] Dashboard (/)
- [ ] Shipments (/shipments)
- [ ] Map (/map)
- [ ] Alerts (/alerts)
- [ ] Analytics (/analytics)

**Expected**: All pages load without errors

### Step 9.6: Test Map Page
Go to Map page

**Expected**:
- ✅ MapBox map loads
- ✅ Vehicle markers visible
- ✅ Routes drawn
- ✅ Can zoom/pan

**If map doesn't load**: Check VITE_MAPBOX_TOKEN in .env

### Step 9.7: Test Real-Time Updates
Keep dashboard open, watch for:
- [ ] KPI numbers update
- [ ] Vehicle positions change
- [ ] New alerts appear

**Expected**: Updates every 5-10 seconds

### Step 9.8: Test Chatbot
Click chatbot icon, type: "What is the status of SH001?"

**Expected**:
- ✅ Message sends
- ✅ AI response appears in 2-5 seconds
- ✅ Response mentions SH001

---

## 📹 Phase 10: Driver Safety Monitor Testing

### Step 10.1: Check Service Status
```bash
docker logs driver_safety --tail 50
```
**Expected**:
```
🚀 Driver Safety Monitor Starting...
✅ Connected to WebSocket server
🎥 Starting driver monitoring for VH001
```

**Note**: This service requires webcam access which Docker can't provide directly.

### Step 10.2: Test Standalone (Outside Docker)
```bash
cd supply-chain-tracker
python webcam.py
```
**Expected**:
- ✅ Webcam window opens
- ✅ Face detection works
- ✅ Eye landmarks visible
- ✅ Status shows "Active"

### Step 10.3: Test Drowsiness Detection
Close your eyes for 2 seconds

**Expected**:
- ✅ Status changes to "DROWSY"
- ✅ Red text appears
- ✅ Beep sound plays
- ✅ Alert inserted in database

### Step 10.4: Verify Alert in Database
```bash
docker exec -it postgres psql -U supply_chain_user -d supply_chain_db -c "SELECT * FROM alerts WHERE alert_type LIKE '%drowsy%' ORDER BY created_at DESC LIMIT 5;"
```
**Expected**: Alert records with "drowsy" type

### Step 10.5: Check Dashboard for Alert
Refresh dashboard alerts page

**Expected**: New driver safety alert visible

---

## 🔄 Phase 11: WebSocket Testing

### Step 11.1: Open Browser Console
Open dashboard, press F12, go to Console tab

### Step 11.2: Check WebSocket Connection
Look for messages like:
```
WebSocket connected
Subscribed to telemetry updates
```

### Step 11.3: Monitor Real-Time Events
Watch console for:
- `telemetry_update` events
- `new_alert` events
- `eta_update` events

**Expected**: Events appear every few seconds

### Step 11.4: Test Reconnection
Restart backend:
```bash
docker-compose restart backend-api
```

**Expected**: Dashboard reconnects automatically within 5 seconds

---

## 📊 Phase 12: End-to-End Flow Testing

### Step 12.1: Full Data Flow
1. GPS Simulator generates position → 
2. Saved to PostgreSQL → 
3. Pathway calculates ETA → 
4. Backend broadcasts via WebSocket → 
5. Dashboard updates in real-time

**Verify**:
```bash
# 1. Check GPS data
docker logs gps_simulator --tail 5

# 2. Check database
docker exec -it postgres psql -U supply_chain_user -d supply_chain_db -c "SELECT COUNT(*) FROM telemetry;"

# 3. Check ETA calculations
docker logs pathway_pipeline --tail 5

# 4. Check dashboard updates
# (Watch dashboard for changes)
```

### Step 12.2: Alert Flow
1. Create manual alert OR trigger driver safety alert
2. Alert saved to database
3. AI Alert Service processes
4. Backend broadcasts
5. Dashboard shows alert

**Test**:
```bash
# Create manual alert
docker exec -it postgres psql -U supply_chain_user -d supply_chain_db -c "INSERT INTO alerts (shipment_id, alert_type, metric, value, is_active) VALUES ('SH001', 'TEST_ALERT', 'test', 'manual test', true);"

# Check dashboard alerts page
```

### Step 12.3: Chatbot Flow
1. User asks question in dashboard
2. Request sent to RAG API
3. RAG queries database for context
4. Groq AI generates response
5. Response displayed in dashboard

**Test**: Use chatbot in dashboard, ask various questions

---

## ✅ Phase 13: Performance Testing

### Step 13.1: Check Resource Usage
```bash
docker stats --no-stream
```
**Expected**:
- CPU < 50% per container
- Memory < 500MB per container
- No containers using excessive resources

### Step 13.2: Check Response Times
```bash
# Test API response time
curl -w "\nTime: %{time_total}s\n" http://localhost:8000/api/stats
```
**Expected**: < 0.5 seconds

### Step 13.3: Check Database Size
```bash
docker exec -it postgres psql -U supply_chain_user -d supply_chain_db -c "SELECT pg_size_pretty(pg_database_size('supply_chain_db'));"
```
**Expected**: < 50MB (for demo data)

---

## 🐛 Phase 14: Error Handling Testing

### Step 14.1: Test API with Invalid Data
```bash
curl -X POST http://localhost:8001/chat ^
  -H "Content-Type: application/json" ^
  -d "{\"query\": \"\"}"
```
**Expected**: Graceful error message

### Step 14.2: Test Database Disconnection
```bash
docker-compose stop postgres
```
**Expected**: Services show connection errors but don't crash

```bash
docker-compose start postgres
```
**Expected**: Services reconnect automatically

### Step 14.3: Test Service Restart
```bash
docker-compose restart backend-api
```
**Expected**: 
- Service restarts cleanly
- Dashboard reconnects
- No data loss

---

## 📝 Testing Checklist Summary

### Docker Services
- [ ] All services build successfully
- [ ] All services start without errors
- [ ] No services in restart loop
- [ ] Logs show normal operation

### Database
- [ ] PostgreSQL accessible
- [ ] All tables created
- [ ] Sample data present
- [ ] Telemetry data growing
- [ ] ETA history populating

### Backend API
- [ ] Health check passes
- [ ] All endpoints respond
- [ ] Swagger UI accessible
- [ ] WebSocket server running

### RAG Chatbot
- [ ] Health check passes
- [ ] Chat endpoint works
- [ ] Groq API connected
- [ ] Responses are contextual

### AI Alert Service
- [ ] Health check passes
- [ ] Stall detection works
- [ ] Driver alerts processed

### GPS Simulator
- [ ] Generating data
- [ ] Data in database
- [ ] Realistic patterns

### Pathway Pipeline
- [ ] Processing telemetry
- [ ] Calculating ETAs
- [ ] Writing to database
- [ ] CSV output generated

### React Dashboard
- [ ] Builds successfully
- [ ] All pages load
- [ ] Map displays correctly
- [ ] Real-time updates work
- [ ] Chatbot functional
- [ ] No console errors

### Driver Safety
- [ ] Webcam detection works
- [ ] Drowsiness detected
- [ ] Alerts created
- [ ] Dashboard shows alerts

### Integration
- [ ] End-to-end data flow works
- [ ] WebSocket updates real-time
- [ ] All services communicate
- [ ] No data loss

---

## 🚨 Common Issues & Solutions

### Issue: Service won't start
**Solution**: Check logs with `docker logs [service_name]`

### Issue: Database connection failed
**Solution**: 
```bash
docker-compose restart postgres
# Wait 10 seconds
docker-compose restart backend-api
```

### Issue: Map not loading
**Solution**: Check VITE_MAPBOX_TOKEN in supply-chain-dashboard/.env

### Issue: Chatbot not responding
**Solution**: Verify GROQ_API_KEY in .env

### Issue: No telemetry data
**Solution**: 
```bash
docker-compose restart gps-simulator
# Wait 30 seconds
```

### Issue: WebSocket not connecting
**Solution**: Check browser console, restart backend-api

---

## 📊 Success Criteria

Project is ready for commit when:
- ✅ All 14 phases pass
- ✅ All checklist items checked
- ✅ No critical errors in logs
- ✅ Dashboard fully functional
- ✅ Real-time updates working
- ✅ All APIs responding
- ✅ Database populated with data

---

## 🎯 Final Verification

Before committing:
1. Run full test suite again
2. Take screenshots of working dashboard
3. Document any known issues
4. Update README with test results
5. Create test report

---

**Ready to start testing? Let me know and I'll guide you through each phase!**
