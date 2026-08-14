FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY core/ ./core/
COPY routers/ ./routers/
COPY zerobeacon_mf_1000_main.py .

EXPOSE 8080

CMD ["uvicorn", "zerobeacon_mf_1000_main:app", "--host", "0.0.0.0", "--port", "8080"]
