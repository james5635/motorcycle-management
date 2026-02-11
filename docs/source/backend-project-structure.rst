Backend Project Structure
=========================

Understanding the organization of the Spring Boot backend codebase.

Directory Layout
----------------

.. code-block:: text

    backend/
    ├── src/
    │   ├── main/
    │   │   ├── java/
    │   │   │   └── com/
    │   │   │       └── example/
    │   │   │           └── demo/
    │   │   │               ├── category/          # Category module
    │   │   │               ├── controller/        # REST controllers
    │   │   │               ├── order/             # Order module
    │   │   │               ├── product/           # Product module
    │   │   │               ├── user/              # User module
    │   │   │               ├── DemoApplication.java
    │   │   │               ├── SecurityConfig.java
    │   │   │               ├── WebConfig.java
    │   │   │               └── DatabaseSeeder.java
    │   │   └── resources/
    │   │       ├── application.properties
    │   │       └── productSeed.json
    │   └── test/
    │       └── java/
    ├── build.gradle.kts
    ├── settings.gradle.kts
    ├── gradlew
    └── scripts/
        └── run.sh

Package Structure
-----------------

The application uses a package-by-feature organization:

Domain Packages
~~~~~~~~~~~~~~~

Each domain has its own package containing entity, repository, service, and DTO classes:

**User Package** (``com.example.demo.user``)

.. code-block:: text

    user/
    ├── User.java              # JPA Entity
    ├── UserRepository.java    # Data access
    ├── UserService.java       # Business logic
    ├── CreateUserDto.java     # Create request DTO
    └── UpdateUserDto.java     # Update request DTO

**Product Package** (``com.example.demo.product``)

.. code-block:: text

    product/
    ├── Product.java           # JPA Entity
    ├── ProductRepository.java # Data access
    ├── ProductService.java    # Business logic
    ├── CreateProductDto.java  # Create request DTO
    └── UpdateProductDto.java  # Update request DTO

**Category Package** (``com.example.demo.category``)

.. code-block:: text

    category/
    ├── Category.java          # JPA Entity
    ├── CategoryRepository.java
    ├── CategoryService.java
    ├── CreateCategoryDto.java
    └── UpdateCategoryDto.java

**Order Package** (``com.example.demo.order``)

.. code-block:: text

    order/
    ├── Order.java             # JPA Entity
    ├── OrderItem.java         # Order item entity
    ├── OrderRepository.java
    ├── OrderItemRepository.java
    ├── OrderService.java
    ├── OrderItemService.java
    ├── CreateOrderDto.java
    ├── UpdateOrderDto.java
    ├── CreateOrderItemDto.java
    └── UpdateOrderItemDto.java

Controllers
~~~~~~~~~~~

All REST controllers are in the ``controller`` package:

.. code-block:: text

    controller/
    ├── AuthController.java      # Authentication endpoints
    ├── UserController.java      # User CRUD operations
    ├── ProductController.java   # Product management
    ├── CategoryController.java  # Category management
    ├── OrderController.java     # Order processing
    ├── OrderItemController.java # Order items
    └── ChatController.java      # AI chat endpoints

Configuration Classes
~~~~~~~~~~~~~~~~~~~~~

**DemoApplication.java**

The main entry point with H2 server configuration:

.. code-block:: java

    @SpringBootApplication
    public class DemoApplication {
        public static void main(String[] args) {
            SpringApplication.run(DemoApplication.class, args);
        }

        @Bean(initMethod = "start", destroyMethod = "stop")
        public Server h2Server() throws SQLException {
            return Server.createTcpServer("-tcp", "-tcpAllowOthers", "-tcpPort", "9092");
        }
    }

**SecurityConfig.java**

Spring Security configuration with BCrypt password encoding:

.. code-block:: java

    @Configuration
    public class SecurityConfig {
        
        @Bean
        public PasswordEncoder passwordEncoder() {
            return new BCryptPasswordEncoder(12);
        }
        
        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) {
            // CSRF disabled for API access, all requests permitted
        }
    }

**WebConfig.java**

Web configuration for serving static files:

.. code-block:: java

    @Configuration
    public class WebConfig implements WebMvcConfigurer {
        @Override
        public void addResourceHandlers(ResourceHandlerRegistry registry) {
            registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:uploads/");
        }
    }

**DatabaseSeeder.java**

Initial data loading on application startup:

.. code-block:: java

    @Component
    public class DatabaseSeeder implements CommandLineRunner {
        // Seeds users, categories, and products from JSON
    }

Build Configuration
-------------------

**build.gradle.kts**

The Gradle build file defines dependencies and build configuration:

.. code-block:: kotlin

    plugins {
        java
        id("org.springframework.boot") version "4.0.1"
        id("io.spring.dependency-management") version "1.1.7"
    }

    java {
        toolchain {
            languageVersion = JavaLanguageVersion.of(21)
        }
    }

    dependencies {
        implementation("org.springframework.boot:spring-boot-starter-data-jpa")
        implementation("org.springframework.boot:spring-boot-starter-webmvc")
        implementation("org.springframework.boot:spring-boot-starter-security")
        runtimeOnly("com.h2database:h2")
        runtimeOnly("com.mysql:mysql-connector-j")
        // ... more dependencies
    }

Resources
---------

**application.properties**

Configuration file for Spring Boot:

.. code-block:: properties

    spring.application.name=demo
    spring.datasource.url=jdbc:h2:mem:testdb
    spring.jpa.hibernate.ddl-auto=update
    # ... more configuration

**productSeed.json**

JSON file containing initial product data for seeding the database.

Naming Conventions
------------------

* **Classes**: PascalCase (e.g., ``UserService``)
* **Methods**: camelCase (e.g., ``getUserById``)
* **Variables**: camelCase (e.g., ``userRepository``)
* **Constants**: UPPER_SNAKE_CASE
* **Packages**: lowercase (e.g., ``com.example.demo.user``)

Design Patterns Used
--------------------

* **Repository Pattern**: Spring Data JPA repositories
* **Service Layer**: Business logic abstraction
* **DTO Pattern**: Data transfer objects for API requests
* **Builder Pattern**: Lombok ``@Builder`` for entity construction
* **Dependency Injection**: Spring IoC container

Next Steps
----------

* :doc:`backend-configuration` - Learn about application properties
* :doc:`backend-entities` - Explore JPA entities
* :doc:`backend-controllers` - Understand REST controllers
