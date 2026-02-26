#!/bin/bash
# Repository Cleanup Script
# Removes deprecated files, test files, and generated data

echo "========================================"
echo "  Repository Cleanup"
echo "========================================"
echo ""

echo "[1/8] Removing deprecated Streamlit dashboard..."
rm -rf dashboard
echo "    Done."

echo "[2/8] Removing test and temporary files..."
rm -f test_api.py
rm -f check_system_status.py
rm -f webcam.py
echo "    Done."

echo "[3/8] Removing outdated documentation..."
rm -f DASHBOARD_INTEGRATION.md
rm -f DASHBOARD_UPDATES.md
rm -f FIXES_APPLIED.md
rm -f MEMBER1_TODO.md
rm -f README_DOCKER.md
rm -f docs/demo_checklist.md
rm -f docs/pitch_script.md
rm -f docs/integration_plan.md
rm -f docs/BRANCH_PROTECTION_SETUP.md
echo "    Done."

echo "[4/8] Removing generated data files..."
rm -f data/gps_stream.csv
rm -f data/sample_shipments.json
rm -f outputs/eta_predictions.csv
rm -f pathway_pipeline/gps_stream.csv
rm -f pathway_pipeline/processed_output.csv
rm -f pathway_pipeline/test/gps_stream.csv
echo "    Done."

echo "[5/8] Removing unused backend files..."
rm -f backend/alerts.py
rm -f backend/config.py
rm -f backend/models.py
rm -f backend/simulator.py
rm -f backend/gps_test.py
rm -rf backend/shared
echo "    Done."

echo "[6/8] Removing unused pathway files..."
rm -f pathway_pipeline/config.py
rm -f pathway_pipeline/eta_logic.py
rm -f pathway_pipeline/schemas.py
rm -rf pathway_pipeline/shared
echo "    Done."

echo "[7/8] Removing unused genai files..."
rm -f genai_rag/chat.py
rm -f genai_rag/document_store.py
rm -f genai_rag/pipeline.py
rm -f genai_rag/prompts.py
rm -f genai_rag/connector-config.json
rm -f genai_rag/docker-compose.yml
rm -rf genai_rag/shared
echo "    Done."

echo "[8/8] Removing unused root files..."
rm -f run_all.sh
rm -f run_all.bat
rm -f requirements.txt
echo "    Done."

echo ""
echo "========================================"
echo "  Cleanup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Review changes: git status"
echo "  2. Test services: docker-compose up"
echo "  3. Commit changes: git add . && git commit -m 'chore: cleanup repository'"
echo ""
