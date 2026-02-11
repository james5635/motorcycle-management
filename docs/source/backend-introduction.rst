Backend Introduction
====================

The Spring Boot backend provides the REST API and data persistence layer for the Motorcycle Shop Management application.

Overview
--------

This backend application is built with Spring Boot and provides a comprehensive REST API for managing:

* User authentication and management
* Product catalog with categories
* Order processing and management
* AI-powered chat assistance
* File uploads (profile images, product images)

Architecture
------------

The backend follows a layered architecture pattern:

.. code-block:: text

    Controller Layer
        |
        v
    Service Layer
        |
        v
    Repository Layer (Spring Data JPA)
        |
        v
    Database (H2/MySQL)

Technology Stack
----------------

**Core Framework**

* **Spring Boot**: 4.0.1 - Application framework
* **Java**: 21 - Programming language
* **Gradle**: Build tool with Kotlin DSL

**Data Layer**

* **Spring Data JPA**: Data access and ORM
* **Hibernate**: JPA provider
* **H2 Database**: In-memory development database
* **MySQL**: Production database support

**Security**

* **Spring Security**: Authentication and authorization
* **BCrypt**: Password hashing

**AI Integration**

* **Spring AI**: AI framework integration
* **Ollama**: Local LLM integration (Gemma 3)

**Utilities**

* **Lombok**: Boilerplate code reduction
* **Jackson**: JSON processing
* **Guava**: Google utilities

Key Features
------------

REST API
~~~~~~~~

Full RESTful API with endpoints for:

* User CRUD operations
* Product management
* Category management
* Order processing
* Authentication
* AI chat streaming

Database
~~~~~~~~

* JPA entities with automatic schema generation
* Support for H2 (development) and MySQL (production)
* Database seeding for initial data

Security
~~~~~~~~

* BCrypt password encryption
* Spring Security configuration
* Session-based authentication
* CORS configuration for frontend access

File Handling
~~~~~~~~~~~~~

* Multipart file uploads for images
* UUID-based file naming to prevent collisions
* Static resource serving

AI Chat
~~~~~~~

* Server-Sent Events (SSE) streaming
* Ollama integration for local LLM
* Support for Gemma 3 models

API Base URL
------------

The backend runs on port 8080 by default:

.. code-block:: text

    http://localhost:8080

All API endpoints are prefixed with the base URL. For example:

* ``GET http://localhost:8080/user`` - List all users
* ``POST http://localhost:8080/auth/login`` - User login
* ``GET http://localhost:8080/product`` - List products

Integration with Frontend
-------------------------

The Flutter mobile app communicates with this backend via HTTP requests. The backend provides:

* JSON responses for all API calls
* Proper HTTP status codes
* Error handling with descriptive messages
* Image URLs for serving uploaded files

Next Steps
----------

* :doc:`backend-installation` - Set up the development environment
* :doc:`backend-project-structure` - Understand the codebase organization
* :doc:`backend-configuration` - Configure application properties
