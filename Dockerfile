# 1. IMAGEN BASE: Usamos la versión oficial de Airflow 3.2.0 con Python 3.11.
FROM apache/airflow:3.2.0-python3.11

# 2. CAMBIO DE USUARIO A ROOT: Para poder instalar paquetes a nivel de sistema operativo (Ubuntu/Debian interno).
USER root

# 3. INSTALAR DEPENDENCIAS DE SISTEMA (C/C++): 
# Muchas librerías de Python (como psycopg2 para Postgres) necesitan compilarse en C.
# build-essential trae compiladores (gcc) y libpq-dev trae las cabeceras de Postgres.
# 'apt-get clean' y 'rm -rf...' borran la caché de instalación para que la imagen pese menos.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 4. VOLVER AL USUARIO AIRFLOW: Por seguridad, nunca ejecutamos la app como root.
USER airflow

# 5. ARGUMENTOS DE CONSTRUCCIÓN: Le pasamos la variable EXTRA_REQUIREMENTS desde el docker-compose.
ARG EXTRA_REQUIREMENTS=""

# 6. INSTALAR LIBRERÍAS CORE: Instalamos gunicorn (servidor web), Celery y el driver de Postgres.
# '--no-cache-dir' es vital para que pip no guarde los instaladores .whl, reduciendo drásticamente el peso de la imagen.
RUN pip install --no-cache-dir \
    gunicorn \
    apache-airflow-providers-celery \
    psycopg2-binary

# 7. INSTALACIÓN DINÁMICA: Si en el .env pusiste AWS u otros proveedores, se instalan aquí mediante el ARG.
RUN if [ -n "$EXTRA_REQUIREMENTS" ]; then \
    pip install --no-cache-dir $EXTRA_REQUIREMENTS ; \
    fi

# 8. DIRECTORIO DE TRABAJO: Define dónde nos paramos por defecto al entrar al contenedor.
WORKDIR /opt/airflow