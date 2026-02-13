FROM python:3.12-slim

WORKDIR /app

# Install runtime dependencies
COPY src/requirements.txt /app/src/requirements.txt
RUN pip install --no-cache-dir -r /app/src/requirements.txt

# Copy application source
COPY src/ /app/src/

EXPOSE 8000

CMD ["python", "src/main.py"]