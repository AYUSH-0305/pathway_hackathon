# Real-Time Supply Chain Visibility & ETA Prediction

## Git Workflow

**IMPORTANT: All development work happens in the `development` branch!**

### Initial Setup
```bash
# Clone the repository
git clone <repository-url>
cd supply-chain-tracker

# Switch to development branch
git checkout development

# Pull latest changes
git pull origin development
```

### Daily Workflow
```bash
# Always work in development branch
git checkout development

# Before starting work, pull latest changes
git pull origin development

# After completing your work
git add .
git commit -m "Your descriptive commit message"
git push origin development
```

### Branch Rules
- **development** - All active development happens here
- **main** - Production-ready code only (merge after demo is stable)
- Never push directly to main
- Final merge to main will be done after successful demo

## Team Structure & Responsibilities

### Member 1 – Pathway & ETA Lead
- Location: `/pathway_pipeline/`
- Focus: GPS data ingestion, cleaning, ETA computation

### Member 2 – Backend, Alerts & Simulator
- Location: `/backend/`
- Focus: GPS simulator, alert logic, FastAPI endpoints

### Member 3 – Dashboard & Visualization
- Location: `/dashboard/`
- Focus: Streamlit UI, live map, alert display

### Member 4 – GenAI, RAG & Pitch
- Location: `/genai_rag/` and `/docs/`
- Focus: RAG chatbot, pitch preparation

## Quick Start

Each member should:
1. Clone repo and switch to development branch (see Git Workflow above)
2. Navigate to their respective folder
3. Create a virtual environment: `python -m venv venv`
4. Activate it: `venv\Scripts\activate` (Windows) or `source venv/bin/activate` (Linux/Mac)
5. Install dependencies: `pip install -r requirements.txt`

## Project Timeline
- Days 1-2: Setup & Learning
- Days 3-4: Core Implementation
- Days 5-6: Integration & Testing
- Days 7-8: Stabilization & API
- Days 9-10: Demo Preparation

## Demo Day Checklist
- [ ] All changes merged and tested in development branch
- [ ] GPS simulator running
- [ ] Pathway pipeline processing data
- [ ] Dashboard showing live movement
- [ ] ETA updating in real-time
- [ ] At least one alert triggered
- [ ] Chatbot answering one query
- [ ] 5-minute pitch ready
- [ ] Final merge to main branch after successful demo
