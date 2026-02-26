@echo off
REM Repository Cleanup Script
REM Removes deprecated files, test files, and generated data

echo ========================================
echo   Repository Cleanup
echo ========================================
echo.

echo [1/8] Removing deprecated Streamlit dashboard...
if exist dashboard rmdir /s /q dashboard
echo     Done.

echo [2/8] Removing test and temporary files...
if exist test_api.py del /f test_api.py
if exist check_system_status.py del /f check_system_status.py
if exist webcam.py del /f webcam.py
echo     Done.

echo [3/8] Removing outdated documentation...
if exist DASHBOARD_INTEGRATION.md del /f DASHBOARD_INTEGRATION.md
if exist DASHBOARD_UPDATES.md del /f DASHBOARD_UPDATES.md
if exist FIXES_APPLIED.md del /f FIXES_APPLIED.md
if exist MEMBER1_TODO.md del /f MEMBER1_TODO.md
if exist README_DOCKER.md del /f README_DOCKER.md
if exist docs\demo_checklist.md del /f docs\demo_checklist.md
if exist docs\pitch_script.md del /f docs\pitch_script.md
if exist docs\integration_plan.md del /f docs\integration_plan.md
if exist docs\BRANCH_PROTECTION_SETUP.md del /f docs\BRANCH_PROTECTION_SETUP.md
echo     Done.

echo [4/8] Removing generated data files...
if exist data\gps_stream.csv del /f data\gps_stream.csv
if exist data\sample_shipments.json del /f data\sample_shipments.json
if exist outputs\eta_predictions.csv del /f outputs\eta_predictions.csv
if exist pathway_pipeline\gps_stream.csv del /f pathway_pipeline\gps_stream.csv
if exist pathway_pipeline\processed_output.csv del /f pathway_pipeline\processed_output.csv
if exist pathway_pipeline\test\gps_stream.csv del /f pathway_pipeline\test\gps_stream.csv
echo     Done.

echo [5/8] Removing unused backend files...
if exist backend\alerts.py del /f backend\alerts.py
if exist backend\config.py del /f backend\config.py
if exist backend\models.py del /f backend\models.py
if exist backend\simulator.py del /f backend\simulator.py
if exist backend\gps_test.py del /f backend\gps_test.py
if exist backend\shared rmdir /s /q backend\shared
echo     Done.

echo [6/8] Removing unused pathway files...
if exist pathway_pipeline\config.py del /f pathway_pipeline\config.py
if exist pathway_pipeline\eta_logic.py del /f pathway_pipeline\eta_logic.py
if exist pathway_pipeline\schemas.py del /f pathway_pipeline\schemas.py
if exist pathway_pipeline\shared rmdir /s /q pathway_pipeline\shared
echo     Done.

echo [7/8] Removing unused genai files...
if exist genai_rag\chat.py del /f genai_rag\chat.py
if exist genai_rag\document_store.py del /f genai_rag\document_store.py
if exist genai_rag\pipeline.py del /f genai_rag\pipeline.py
if exist genai_rag\prompts.py del /f genai_rag\prompts.py
if exist genai_rag\connector-config.json del /f genai_rag\connector-config.json
if exist genai_rag\docker-compose.yml del /f genai_rag\docker-compose.yml
if exist genai_rag\shared rmdir /s /q genai_rag\shared
echo     Done.

echo [8/8] Removing unused root files...
if exist run_all.sh del /f run_all.sh
if exist run_all.bat del /f run_all.bat
if exist requirements.txt del /f requirements.txt
echo     Done.

echo.
echo ========================================
echo   Cleanup Complete!
echo ========================================
echo.
echo Next steps:
echo   1. Review changes: git status
echo   2. Test services: docker-compose up
echo   3. Commit changes: git add . ^&^& git commit -m "chore: cleanup repository"
echo.
pause
