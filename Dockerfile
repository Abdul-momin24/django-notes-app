FROM python:3.9-slim

WORKDIR /app/backend

# Install system dependencies (gcc, mysql dev libs, netcat for waiting)
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
       gcc \
       default-libmysqlclient-dev \
       pkg-config \
       netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (better layer caching)
COPY requirements.txt /app/backend

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install --no-cache-dir mysqlclient \
    && pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /app/backend

EXPOSE 8000

# Container start is handled in docker-compose.yml (so no CMD/ENTRYPOINT here)
