FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    cron curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Cron entries
COPY crontab /etc/cron.d/magnus-scrapers
RUN chmod 0644 /etc/cron.d/magnus-scrapers && crontab /etc/cron.d/magnus-scrapers

CMD ["cron", "-f"]
