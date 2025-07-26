from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
import subprocess
import os
from pathlib import Path

app = FastAPI(title="Export CSV FaaS", version="1.0.0")

@app.get("/")
def health_check():
    return {"status": "healthy", "service": "ExportCsvFn"}

@app.post("/exports/{survey_id}")
def export_csv(survey_id: int):
    """
    Trigger HTTP manual para exportar CSV de una encuesta
    """
    try:
        # Verificar que el script bash existe
        bash_script = Path("ExportCsvFn.bash")
        if not bash_script.exists():
            raise HTTPException(status_code=500, detail="Export script not found")
        
        # Ejecutar el script bash con el ID de la encuesta
        result = subprocess.run(
            ["bash", "ExportCsvFn.bash", str(survey_id)], 
            capture_output=True, 
            text=True, 
            timeout=300  # 5 minutos timeout
        )
        
        if result.returncode == 0:
            # Verificar si el archivo CSV fue creado
            csv_file = Path(f"./exports/encuesta_{survey_id}.csv")
            if csv_file.exists():
                return {
                    "status": "success",
                    "message": f"CSV export completed for survey {survey_id}",
                    "file_path": str(csv_file),
                    "survey_id": survey_id
                }
            else:
                return {
                    "status": "warning", 
                    "message": "Export process completed but CSV file not found",
                    "survey_id": survey_id
                }
        else:
            error_detail = result.stderr if result.stderr else "Unknown error during export"
            raise HTTPException(
                status_code=500, 
                detail=f"CSV export failed: {error_detail}"
            )
            
    except subprocess.TimeoutExpired:
        raise HTTPException(
            status_code=504, 
            detail="CSV export timed out after 5 minutes"
        )
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Unexpected error: {str(e)}"
        )

@app.get("/exports/{survey_id}/status")
def check_export_status(survey_id: int):
    """
    Verificar si existe el archivo CSV exportado para una encuesta
    """
    csv_file = Path(f"./exports/encuesta_{survey_id}.csv")
    
    if csv_file.exists():
        return {
            "status": "exists",
            "survey_id": survey_id,
            "file_path": str(csv_file),
            "file_size": csv_file.stat().st_size
        }
    else:
        return {
            "status": "not_found",
            "survey_id": survey_id,
            "message": "CSV file not found for this survey"
        }
