FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 80
# Access logs to stdout (-), error logs to stderr (-)
CMD ["gunicorn", "--bind", "0.0.0.0:3000", "--access-logfile", "-", "--error-logfile", "-", "app:app"]
