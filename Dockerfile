# FROM python:3.8-slim

# WORKDIR /app
# COPY . /app

# RUN apt-get update && \
#     apt-get install -y default-mysql-client && \
#     pip install --no-cache-dir flask mysql-connector-python boto3

# EXPOSE 80
# CMD ["python", "app.py"]


FROM python:3.8-slim

WORKDIR /app

COPY . /app

RUN apt-get update && \
    apt-get install -y default-mysql-client && \
    pip install --no-cache-dir flask mysql-connector-python boto3 gunicorn && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80

# Gunicorn server bereikt de python applicatie.
# -b 0.0.0.0:80 bind de server aan alle netwerkinterfaces op poort 80 & maakt het bereikbaar van buiten
# w 8 draait de applicatie met 8 workesrs
CMD ["gunicorn", "-b", "0.0.0.0:80", "-w", "8", "app:app"]
