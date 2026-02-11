Backend Configuration
=====================

Comprehensive guide to configuring the Spring Boot backend application.

Application Properties
----------------------

The main configuration file is located at ``src/main/resources/application.properties``.

Basic Configuration
~~~~~~~~~~~~~~~~~~~

.. code-block:: properties

    spring.application.name=demo

Database Configuration
----------------------

H2 In-Memory Database (Development)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Default configuration for development:

.. code-block:: properties

    spring.datasource.url=jdbc:h2:mem:testdb
    spring.jpa.properties.hibernate.show_sql=true
    spring.jpa.hibernate.ddl-auto=update

This configuration:

* Creates an in-memory H2 database named ``testdb``
* Enables SQL logging for debugging
* Automatically creates/updates database schema

H2 Console Access
~~~~~~~~~~~~~~~~~

Access the H2 console at ``http://localhost:8080/h2-console``

Connection details:

* **JDBC URL**: ``jdbc:h2:mem:testdb``
* **Username**: ``sa``
* **Password**: (leave empty)

MySQL Database (Production)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

To use MySQL, comment out H2 and uncomment MySQL configuration:

.. code-block:: properties

    # spring.datasource.url=jdbc:h2:mem:testdb
    
    spring.datasource.url=jdbc:mysql://localhost:3306/db
    spring.datasource.username=root
    spring.datasource.password=your_password
    spring.jpa.properties.hibernate.show_sql=true
    spring.jpa.hibernate.ddl-auto=update

Make sure to:

1. Create the database ``db`` in MySQL
2. Update the username and password
3. Include MySQL connector dependency (already in build.gradle.kts)

JPA/Hibernate Configuration
---------------------------

Schema Generation
~~~~~~~~~~~~~~~~~

.. code-block:: properties

    spring.jpa.hibernate.ddl-auto=update

Options:

* ``none``: No schema generation
* ``update``: Update existing schema (recommended for development)
* ``create``: Create schema on startup, destroy on shutdown
* ``create-drop``: Create schema on startup, drop on shutdown
* ``validate``: Validate schema, make no changes

SQL Logging
~~~~~~~~~~~

.. code-block:: properties

    spring.jpa.properties.hibernate.show_sql=true
    spring.jpa.properties.hibernate.format_sql=true

Naming Strategy (Optional)
~~~~~~~~~~~~~~~~~~~~~~~~~~

For legacy naming compatibility:

.. code-block:: properties

    spring.jpa.hibernate.naming.implicit-strategy=org.hibernate.boot.model.naming.ImplicitNamingStrategyLegacyJpaImpl
    spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl

Server Configuration
--------------------

Port Configuration
~~~~~~~~~~~~~~~~~~

Default port is 8080. To change:

.. code-block:: properties

    server.port=8081

Session Configuration
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: properties

    server.servlet.session.cookie.same-site=lax

Security Configuration
----------------------

Session-based authentication is configured in ``SecurityConfig.java``:

.. code-block:: java

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }

BCrypt strength (cost factor):

* Default: 10
* Recommended: 12-14
* Higher values = more secure but slower

Multipart File Upload
---------------------

Configure file upload limits:

.. code-block:: properties

    spring.servlet.multipart.max-file-size=5MB
    spring.servlet.multipart.max-request-size=5MB

Adjust these values based on your maximum expected file size.

AI/Ollama Configuration
-----------------------

Ollama Base URL
~~~~~~~~~~~~~~~

.. code-block:: properties

    spring.ai.ollama.base-url=http://localhost:11434

Change if Ollama runs on a different host or port.

Model Strategy
~~~~~~~~~~~~~~

.. code-block:: properties

    spring.ai.ollama.init.pull-model-strategy=when_missing

Options:

* ``never``: Never pull models automatically
* ``when_missing``: Pull only if model doesn't exist (recommended)
* ``always``: Always pull on startup

Model Selection
~~~~~~~~~~~~~~~

Available models:

.. code-block:: properties

    # Lightweight model (270M parameters)
    spring.ai.ollama.chat.options.model=gemma3:270m
    
    # Medium model (1B parameters)
    # spring.ai.ollama.chat.options.model=gemma3:1b
    
    # Alternative model
    # spring.ai.ollama.chat.options.model=llama3.2:1b

Profile-Specific Configuration
------------------------------

Create separate configuration files for different environments:

**application-dev.properties** (Development)

.. code-block:: properties

    spring.datasource.url=jdbc:h2:mem:testdb
    spring.jpa.hibernate.ddl-auto=create-drop
    logging.level.org.springframework=DEBUG

**application-prod.properties** (Production)

.. code-block:: properties

    spring.datasource.url=jdbc:mysql://localhost:3306/production_db
    spring.jpa.hibernate.ddl-auto=validate
    logging.level.org.springframework=WARN

Activate a profile:

.. code-block:: bash

    ./gradlew bootRun --args='--spring.profiles.active=dev'

Or set environment variable:

.. code-block:: bash

    export SPRING_PROFILES_ACTIVE=prod

Logging Configuration
---------------------

Configure logging levels in ``application.properties``:

.. code-block:: properties

    logging.level.root=INFO
    logging.level.com.example.demo=DEBUG
    logging.level.org.springframework.web=DEBUG
    logging.level.org.hibernate.SQL=DEBUG

Complete Configuration Example
------------------------------

.. code-block:: properties

    spring.application.name=demo
    
    # Database
    spring.datasource.url=jdbc:h2:mem:testdb
    spring.jpa.properties.hibernate.show_sql=true
    spring.jpa.hibernate.ddl-auto=update
    
    # Security
    server.servlet.session.cookie.same-site=lax
    
    # File Upload
    spring.servlet.multipart.max-file-size=5MB
    spring.servlet.multipart.max-request-size=5MB
    
    # AI/Ollama
    spring.ai.ollama.base-url=http://localhost:11434
    spring.ai.ollama.init.pull-model-strategy=when_missing
    spring.ai.ollama.chat.options.model=gemma3:270m
    
    # Logging
    logging.level.com.example.demo=DEBUG

Environment Variables
---------------------

You can use environment variables in ``application.properties``:

.. code-block:: properties

    spring.datasource.password=${DB_PASSWORD:default_password}
    spring.ai.ollama.base-url=${OLLAMA_URL:http://localhost:11434}

Set environment variables:

.. code-block:: bash

    export DB_PASSWORD=secret_password
    export OLLAMA_URL=http://192.168.1.100:11434

Next Steps
----------

* :doc:`backend-entities` - Learn about JPA entities
* :doc:`backend-security` - Security configuration details
