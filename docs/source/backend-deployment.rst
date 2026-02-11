Backend Deployment
==================

Guide for deploying the Spring Boot backend to various environments.

Overview
--------

The Spring Boot application can be deployed in multiple ways:

* **JAR file**: Standalone executable
* **Docker container**: Containerized deployment
* **Traditional server**: Tomcat, Jetty
* **Cloud platforms**: AWS, Azure, Heroku

Building for Production
-----------------------

Create Executable JAR
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    ./gradlew bootJar

The JAR file is created at:

.. code-block:: text

    build/libs/demo-0.0.1-SNAPSHOT.jar

Run the JAR:

.. code-block:: bash

    java -jar build/libs/demo-0.0.1-SNAPSHOT.jar

Production Configuration
------------------------

Create ``application-prod.properties``:

.. code-block:: properties

    # Application
    spring.application.name=demo
    server.port=8080
    
    # Database - MySQL
    spring.datasource.url=jdbc:mysql://${DB_HOST:localhost}:3306/${DB_NAME:motorcycle_shop}
    spring.datasource.username=${DB_USERNAME:root}
    spring.datasource.password=${DB_PASSWORD}
    spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
    
    # JPA
    spring.jpa.hibernate.ddl-auto=validate
    spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
    
    # Security
    server.servlet.session.cookie.same-site=strict
    server.servlet.session.cookie.secure=true
    server.servlet.session.cookie.http-only=true
    
    # File Upload
    spring.servlet.multipart.max-file-size=10MB
    spring.servlet.multipart.max-request-size=10MB
    
    # AI/Ollama
    spring.ai.ollama.base-url=${OLLAMA_URL:http://localhost:11434}
    spring.ai.ollama.chat.options.model=gemma3:270m
    
    # Logging
    logging.level.root=WARN
    logging.level.com.example.demo=INFO
    logging.file.name=/var/log/motorcycle-shop/app.log

Environment Variables
~~~~~~~~~~~~~~~~~~~~~

Set required environment variables:

.. code-block:: bash

    export SPRING_PROFILES_ACTIVE=prod
    export DB_HOST=your-db-host
    export DB_NAME=motorcycle_shop
    export DB_USERNAME=db_user
    export DB_PASSWORD=your_secure_password
    export OLLAMA_URL=http://localhost:11434

Run with production profile:

.. code-block:: bash

    java -jar -Dspring.profiles.active=prod build/libs/demo-0.0.1-SNAPSHOT.jar

Docker Deployment
-----------------

Dockerfile
~~~~~~~~~~

Create ``Dockerfile`` in project root:

.. code-block:: dockerfile

    # Build stage
    FROM eclipse-temurin:21-jdk-alpine AS builder
    
    WORKDIR /app
    COPY build.gradle.kts settings.gradle.kts ./
    COPY gradle ./gradle
    COPY gradlew ./
    COPY src ./src
    
    RUN ./gradlew bootJar --no-daemon
    
    # Runtime stage
    FROM eclipse-temurin:21-jre-alpine
    
    WORKDIR /app
    
    # Create uploads directory
    RUN mkdir -p uploads
    
    # Copy JAR from builder
    COPY --from=builder /app/build/libs/*.jar app.jar
    
    # Expose port
    EXPOSE 8080
    
    # Run application
    ENTRYPOINT ["java", "-jar", "app.jar"]

Build Docker Image
~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    docker build -t motorcycle-shop-backend .

Run Container
~~~~~~~~~~~~~

.. code-block:: bash

    docker run -d \
      --name motorcycle-backend \
      -p 8080:8080 \
      -e SPRING_PROFILES_ACTIVE=prod \
      -e DB_HOST=host.docker.internal \
      -e DB_PASSWORD=secret \
      -v $(pwd)/uploads:/app/uploads \
      motorcycle-shop-backend

Docker Compose
~~~~~~~~~~~~~~

Create ``docker-compose.yml``:

.. code-block:: yaml

    version: '3.8'
    
    services:
      app:
        build: .
        ports:
          - "8080:8080"
        environment:
          - SPRING_PROFILES_ACTIVE=prod
          - DB_HOST=db
          - DB_NAME=motorcycle_shop
          - DB_USERNAME=root
          - DB_PASSWORD=password
          - OLLAMA_URL=http://ollama:11434
        depends_on:
          - db
          - ollama
        volumes:
          - ./uploads:/app/uploads
      
      db:
        image: mysql:8.0
        environment:
          MYSQL_ROOT_PASSWORD: password
          MYSQL_DATABASE: motorcycle_shop
        ports:
          - "3306:3306"
        volumes:
          - mysql-data:/var/lib/mysql
      
      ollama:
        image: ollama/ollama
        ports:
          - "11434:11434"
        volumes:
          - ollama-data:/root/.ollama
    
    volumes:
      mysql-data:
      ollama-data:

Run with Docker Compose:

.. code-block:: bash

    docker-compose up -d

Cloud Deployment
----------------

AWS Elastic Beanstalk
~~~~~~~~~~~~~~~~~~~~~

1. Create ``.ebextensions/java.config``:

.. code-block:: yaml

    option_settings:
      aws:elasticbeanstalk:container:java:
        JVMOptions: -Xmx512m -Dspring.profiles.active=prod
      aws:elasticbeanstalk:application:environment:
        DB_HOST: your-rds-endpoint
        DB_PASSWORD: your-password

2. Package application:

.. code-block:: bash

    zip -r deploy.zip build/libs/*.jar .ebextensions/

3. Upload to Elastic Beanstalk

Heroku
~~~~~~

Create ``Procfile``:

.. code-block:: text

    web: java -Dserver.port=$PORT -jar build/libs/demo-0.0.1-SNAPSHOT.jar

Create ``system.properties``:

.. code-block:: properties

    java.runtime.version=21

Deploy:

.. code-block:: bash

    git push heroku main

Render/Railway
~~~~~~~~~~~~~~

Create ``render.yaml``:

.. code-block:: yaml

    services:
      - type: web
        name: motorcycle-shop-backend
        runtime: java
        buildCommand: ./gradlew bootJar
        startCommand: java -jar build/libs/demo-0.0.1-SNAPSHOT.jar
        envVars:
          - key: SPRING_PROFILES_ACTIVE
            value: prod
          - key: DB_HOST
            fromDatabase:
              name: motorcycle-db
              property: host

Traditional Server Deployment
-----------------------------

Systemd Service
~~~~~~~~~~~~~~~

Create ``/etc/systemd/system/motorcycle-shop.service``:

.. code-block:: ini

    [Unit]
    Description=Motorcycle Shop Backend
    After=network.target
    
    [Service]
    Type=simple
    User=appuser
    WorkingDirectory=/opt/motorcycle-shop
    ExecStart=/usr/bin/java -jar -Dspring.profiles.active=prod app.jar
    Restart=always
    Environment="DB_PASSWORD=secret"
    Environment="OLLAMA_URL=http://localhost:11434"
    
    [Install]
    WantedBy=multi-user.target

Enable and start:

.. code-block:: bash

    sudo systemctl enable motorcycle-shop
    sudo systemctl start motorcycle-shop
    sudo systemctl status motorcycle-shop

Nginx Reverse Proxy
~~~~~~~~~~~~~~~~~~~

Configure Nginx:

.. code-block:: nginx

    server {
        listen 80;
        server_name api.yourdomain.com;
        
        location / {
            proxy_pass http://localhost:8080;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
        
        client_max_body_size 10M;
    }

SSL with Let's Encrypt
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    sudo certbot --nginx -d api.yourdomain.com

Pre-Deployment Checklist
------------------------

.. list-table::
   :header-rows: 1

   * - Item
     - Status
   * - Application tests passing
     - [ ]
   * - Production configuration created
     - [ ]
   * - Environment variables configured
     - [ ]
   * - Database migrations applied
     - [ ]
   * - SSL certificate installed
     - [ ]
   * - Log rotation configured
     - [ ]
   * - Health check endpoint working
     - [ ]
   * - Backup strategy in place
     - [ ]
   * - Monitoring configured
     - [ ]

Monitoring and Health Checks
----------------------------

Health Endpoint
~~~~~~~~~~~~~~~

Spring Boot Actuator provides health checks:

Add dependency:

.. code-block:: kotlin

    implementation("org.springframework.boot:spring-boot-starter-actuator")

Access health check:

.. code-block:: bash

    curl http://localhost:8080/actuator/health

Response:

.. code-block:: json

    {
        "status": "UP"
    }

Logging
~~~~~~~

Monitor logs:

.. code-block:: bash

    tail -f /var/log/motorcycle-shop/app.log

Or with Docker:

.. code-block:: bash

    docker logs -f motorcycle-backend

Troubleshooting
---------------

Application Won't Start
~~~~~~~~~~~~~~~~~~~~~~~

Check:

1. Database connection
2. Environment variables
3. Port availability
4. Java version

Out of Memory
~~~~~~~~~~~~~

Increase heap size:

.. code-block:: bash

    java -Xmx1g -jar app.jar

Database Connection Issues
~~~~~~~~~~~~~~~~~~~~~~~~~~

Verify:

.. code-block:: bash

    # Test MySQL connection
    mysql -h your-host -u user -p
    
    # Check firewall rules
    telnet your-host 3306

Ollama Not Responding
~~~~~~~~~~~~~~~~~~~~~

Check:

.. code-block:: bash

    curl http://localhost:11434/api/tags
    
    # Restart Ollama
    ollama serve

Next Steps
----------

* Monitor application metrics
* Set up alerting
* Configure automated backups
* Document API for consumers
