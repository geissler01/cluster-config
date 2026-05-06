data-cluster/
│
├── proxy/                   <-- Se levanta SOLO en la instancia Proxy
│   ├── docker-compose.yml   (Contiene Nginx Proxy Manager)
│   └── .env                 (Variables: puertos, credenciales NPM)
│
├── rabbitmq/                <-- Se levanta SOLO en la instancia Rabbit
│   ├── docker-compose.yml   (Contiene RabbitMQ management)
│   └── .env                 (Variables: RABBITMQ_DEFAULT_USER, RABBITMQ_DEFAULT_PASS)
│
├── master/                  <-- Se levanta SOLO en la instancia Master
│   ├── docker-compose.yml   (Postgres, Airflow Webserver, Airflow Scheduler, Flower)
│   └── .env                 (Variables: Conexión a DB, Conexión a Rabbit, AIRFLOW_UID)
│
├── worker/                  <-- Se levanta en tus 3 instancias Workers
│   ├── docker-compose.yml   (Airflow Celery Worker)
│   └── .env                 (Variables: Conexión a DB del Master, Conexión a Rabbit)
│
└── .gitignore               (Ignora TODOS los archivos .env para que no suban a GitHub)

