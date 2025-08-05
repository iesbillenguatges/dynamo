
FROM python:3.11-slim

# Instal·la dependències del sistema si calen
RUN apt-get update && apt-get install -y build-essential

# Directori de treball
WORKDIR /app

# Copia tot el contingut del projecte, incloent app/templates
COPY . .

# Instal·la dependències Python
RUN pip install --no-cache-dir -r requirements.txt

# Exposa el port
EXPOSE 8000

# Comanda per iniciar FastAPI amb Uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
