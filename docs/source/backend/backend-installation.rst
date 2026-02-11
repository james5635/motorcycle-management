Backend Installation
====================

This guide walks you through setting up the Spring Boot backend development environment.

Prerequisites
-------------

Before you begin, ensure you have the following installed:

**Required Software**

* **Java Development Kit (JDK) 21** or higher
* **Gradle** (or use the included Gradle wrapper)
* **Git** for version control

**Optional for AI Features**

* **Ollama** - For local AI chat functionality

Install Java
------------

**Ubuntu/Debian**

.. code-block:: bash

    sudo apt update
    sudo apt install openjdk-21-jdk

**macOS (using Homebrew)**

.. code-block:: bash

    brew install openjdk@21

**Windows**

Download and install from `Oracle JDK <https://www.oracle.com/java/technologies/downloads/>`_ or use OpenJDK.

Verify installation:

.. code-block:: bash

    java -version
    # Should show Java 21

Clone and Setup
---------------

1. Navigate to the backend directory:

.. code-block:: bash

    cd backend

2. The project includes Gradle wrapper, so you don't need to install Gradle separately.

Build the Project
-----------------

Using Gradle wrapper (recommended):

.. code-block:: bash

    ./gradlew build

On Windows:

.. code-block:: bat

    gradlew.bat build

Run the Application
-------------------

Development Mode
~~~~~~~~~~~~~~~~

Start the application with hot reload:

.. code-block:: bash

    ./gradlew bootRun

The application will start on ``http://localhost:8080``

Using the Run Script
~~~~~~~~~~~~~~~~~~~~

A convenience script is provided:

.. code-block:: bash

    chmod +x scripts/run.sh
    ./scripts/run.sh

Verify Installation
-------------------

Once running, test the API:

.. code-block:: bash

    curl http://localhost:8080/user

You should receive a JSON response with user data (or an empty array if no users exist).

Setup Ollama (Optional)
-----------------------

For AI chat functionality:

1. Install Ollama from https://ollama.com

2. Pull the required model:

.. code-block:: bash

    ollama pull gemma3:270m

3. Ensure Ollama is running on port 11434 (default)

4. The backend will automatically connect to Ollama if available

IDE Configuration
-----------------

**IntelliJ IDEA**

1. Open the ``backend`` folder in IntelliJ
2. IntelliJ will automatically detect the Gradle project
3. Import the project as a Gradle project
4. Enable annotation processing for Lombok:
   * Settings > Build > Annotation Processors
   * Enable annotation processing

**VS Code**

1. Install the Extension Pack for Java
2. Install the Gradle for Java extension
3. Open the ``backend`` folder
4. The project will be recognized automatically

Development Configuration
-------------------------

The application uses H2 in-memory database by default for development. Data is seeded automatically on startup via ``DatabaseSeeder``.

To view the H2 console during development:

1. Navigate to ``http://localhost:8080/h2-console``
2. Use the following credentials:
   * JDBC URL: ``jdbc:h2:mem:testdb``
   * Username: ``sa``
   * Password: (leave empty)

Common Issues
-------------

**Port 8080 Already in Use**

.. code-block:: bash

    # Find process using port 8080
    lsof -i :8080
    # Kill the process
    kill -9 <PID>

Or change the port in ``application.properties``:

.. code-block:: properties

    server.port=8081

**Build Fails Due to Java Version**

Ensure JAVA_HOME is set correctly:

.. code-block:: bash

    export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
    export PATH=$JAVA_HOME/bin:$PATH

Next Steps
----------

* :doc:`backend-configuration` - Learn about application configuration
* :doc:`backend-project-structure` - Explore the codebase structure
