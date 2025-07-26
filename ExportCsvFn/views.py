from rest_framework.views import APIView
import subprocess

class ExportCsvFn:
    ruta = "ExportCsvFN.bash"
    def __init__(self, id_survey):
        self.id_survey = id_survey

    def export(self):
        result = subprocess.run(["bash", self.ruta, str(self.id_survey)], capture_output=True, text=True)
        return result.stdout
