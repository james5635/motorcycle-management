Backend Controllers
===================

REST controllers handle HTTP requests and define the API endpoints for the application.

Overview
--------

Controllers use Spring's ``@RestController`` annotation and handle:

* Request mapping (URL paths and HTTP methods)
* Request parsing (JSON, form data, multipart)
* Response generation (JSON responses)
* HTTP status codes
* Error handling

Base Annotations
----------------

.. code-block:: java

    @RestController
    @RequestMapping("/api-path")
    public class ControllerName {
        // endpoints
    }

Common Method Annotations:

* ``@GetMapping`` - Handle GET requests
* ``@PostMapping`` - Handle POST requests
* ``@PutMapping`` - Handle PUT requests
* ``@DeleteMapping`` - Handle DELETE requests
* ``@PathVariable`` - Extract URL parameters
* ``@RequestBody`` - Parse JSON request body
* ``@RequestParam`` - Extract query parameters
* ``@RequestPart`` - Handle multipart form data

AuthController
--------------

Handles user authentication.

**Base Path**: ``/auth``

.. code-block:: java

    @RestController
    @RequestMapping("/auth")
    public class AuthController {
        
        private final UserService userService;

        public AuthController(UserService userService) {
            this.userService = userService;
        }

        @PostMapping("/login")
        public ResponseEntity<?> loginUser(@RequestBody Map<String, String> credentials) {
            String username = credentials.get("username");
            String password = credentials.get("password");
            
            if (username == null || password == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "username or password cannot be null"));
            }
            
            return userService.loginUser(username, password);
        }
    }

**Endpoints**

.. list-table::
   :header-rows: 1

   * - Method
     - Endpoint
     - Description
   * - POST
     - ``/auth/login``
     - Authenticate user with username and password

**Request Body**:

.. code-block:: json

    {
        "username": "jame",
        "password": "123456"
    }

**Response**:

.. code-block:: json

    {
        "userId": 1
    }

UserController
--------------

Handles user CRUD operations with profile image upload.

**Base Path**: ``/user``

.. code-block:: java

    @RestController
    @RequestMapping("/user")
    public class UserController {
        
        private final UserService userService;

        public UserController(UserService userService) {
            this.userService = userService;
        }

        @GetMapping
        public List<User> getAllUser() {
            return userService.getAllUser();
        }

        @GetMapping("/{id}")
        public User getUser(@PathVariable long id) {
            return userService.getUser(id);
        }

        @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
        public User createUser(
                @RequestPart("user") CreateUserDto userDto,
                @RequestPart(value = "profileImage", required = false) MultipartFile file) 
                throws IOException {
            
            String uploadDir = "uploads/";
            Files.createDirectories(Paths.get(uploadDir));
            
            String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
            Path filePath = Paths.get(uploadDir, filename);
            Files.copy(file.getInputStream(), filePath);
            
            return userService.createUser(userDto, filename);
        }

        @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
        public User updateUser(
                @PathVariable long id, 
                @RequestPart("user") UpdateUserDto dto,
                @RequestPart(value = "profileImage", required = false) MultipartFile file) 
                throws IOException {
            
            if (file != null && !file.isEmpty()) {
                // Handle file upload similar to create
            }
            
            return userService.updateUser(id, dto);
        }

        @DeleteMapping("/{id}")
        public void deleteUser(@PathVariable long id) {
            userService.deleteUser(id);
        }
    }

**Endpoints**

.. list-table::
   :header-rows: 1

   * - Method
     - Endpoint
     - Description
   * - GET
     - ``/user``
     - List all users
   * - GET
     - ``/user/{id}``
     - Get user by ID
   * - POST
     - ``/user``
     - Create new user with profile image
   * - PUT
     - ``/user/{id}``
     - Update user with optional image
   * - DELETE
     - ``/user/{id}``
     - Delete user

**Create User Request** (multipart/form-data):

* **user**: JSON string with user data
* **profileImage**: Image file (optional)

Example user JSON:

.. code-block:: json

    {
        "username": "john_doe",
        "email": "john@example.com",
        "password": "secure123",
        "phoneNumber": "1234567890",
        "address": "123 Main St",
        "role": "customer"
    }

ProductController
-----------------

Manages product catalog with image upload.

**Base Path**: ``/product``

**Key Endpoints**:

.. list-table::
   :header-rows: 1

   * - Method
     - Endpoint
     - Description
   * - GET
     - ``/product``
     - List all products
   * - GET
     - ``/product/{id}``
     - Get product by ID
   * - GET
     - ``/product/category/{categoryId}``
     - Get products by category
   * - POST
     - ``/product``
     - Create product with image
   * - PUT
     - ``/product/{id}``
     - Update product
   * - DELETE
     - ``/product/{id}``
     - Delete product

CategoryController
------------------

Manages product categories.

**Base Path**: ``/category``

**Endpoints**:

.. list-table::
   :header-rows: 1

   * - Method
     - Endpoint
     - Description
   * - GET
     - ``/category``
     - List all categories
   * - GET
     - ``/category/{id}``
     - Get category by ID
   * - POST
     - ``/category``
     - Create category
   * - PUT
     - ``/category/{id}``
     - Update category
   * - DELETE
     - ``/category/{id}``
     - Delete category

OrderController
---------------

Handles order processing.

**Base Path**: ``/order``

**Endpoints**:

.. list-table::
   :header-rows: 1

   * - Method
     - Endpoint
     - Description
   * - GET
     - ``/order``
     - List all orders
   * - GET
     - ``/order/{id}``
     - Get order by ID
   * - GET
     - ``/order/user/{userId}``
     - Get orders for specific user
   * - POST
     - ``/order``
     - Create new order
   * - PUT
     - ``/order/{id}``
     - Update order
   * - DELETE
     - ``/order/{id}``
     - Delete order

**Create Order Request**:

.. code-block:: json

    {
        "userId": 1,
        "totalAmount": 15999.99,
        "shippingAddress": "123 Main St, City, Country",
        "paymentMethod": "credit_card",
        "items": [
            {
                "productId": 1,
                "quantity": 2,
                "unitPrice": 7999.99
            }
        ]
    }

OrderItemController
-------------------

Manages individual order items.

**Base Path**: ``/order-item``

**Endpoints**:

.. list-table::
   :header-rows: 1

   * - Method
     - Endpoint
     - Description
   * - GET
     - ``/order-item``
     - List all order items
   * - GET
     - ``/order-item/{id}``
     - Get order item by ID
   * - GET
     - ``/order-item/order/{orderId}``
     - Get items for specific order
   * - POST
     - ``/order-item``
     - Create order item
   * - PUT
     - ``/order-item/{id}``
     - Update order item
   * - DELETE
     - ``/order-item/{id}``
     - Delete order item

ChatController
--------------

Provides AI chat functionality with Server-Sent Events (SSE).

**Base Path**: ``/chat``

.. code-block:: java

    @RestController
    @RequestMapping("/chat")
    public class ChatController {
        
        private final ChatModel chatModel;

        public ChatController(ChatModel chatModel) {
            this.chatModel = chatModel;
        }

        @PostMapping(produces = MediaType.TEXT_EVENT_STREAM_VALUE)
        public Flux<String> generate(@RequestBody Map<String, String> request) {
            String prompt = request.get("prompt");
            
            if (prompt == null || prompt.isBlank()) {
                return Flux.just("error: prompt is required");
            }
            
            return chatModel.stream(prompt).concatWithValues("[DONE]");
        }
    }

**Endpoint**:

.. list-table::
   :header-rows: 1

   * - Method
     - Endpoint
     - Content-Type
     - Description
   * - POST
     - ``/chat``
     - text/event-stream
     - Stream AI responses

**Request**:

.. code-block:: json

    {
        "prompt": "Tell me about motorcycles"
    }

**Response**: SSE stream

.. code-block:: text

    data: Motorcycles are two-wheeled vehicles...
    
    data: They come in various types including...
    
    data: [DONE]

HomeController
--------------

Simple controller for root path.

**Base Path**: ``/``

.. code-block:: java

    @RestController
    public class HomeController {
        
        @GetMapping("/")
        public String home() {
            return "Motorcycle Shop Management API";
        }
    }

ResponseEntity Patterns
-----------------------

Use ``ResponseEntity`` for full control over responses:

.. code-block:: java

    // Success with data
    return ResponseEntity.ok(user);

    // Created
    return ResponseEntity.status(HttpStatus.CREATED).body(user);

    // Bad request
    return ResponseEntity.badRequest()
        .body(Map.of("error", "Invalid input"));

    // Not found
    return ResponseEntity.status(HttpStatus.NOT_FOUND)
        .body(Map.of("error", "User not found"));

    // Unauthorized
    return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
        .body(Map.of("error", "Invalid credentials"));

Error Handling
--------------

Use try-catch for error handling:

.. code-block:: java

    @GetMapping("/{id}")
    public ResponseEntity<?> getUser(@PathVariable long id) {
        try {
            User user = userService.getUser(id);
            return ResponseEntity.ok(user);
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(Map.of("error", "User not found"));
        }
    }

CORS Configuration
------------------

CORS is configured in ``WebConfig.java`` to allow frontend access:

.. code-block:: java

    @Configuration
    public class WebConfig implements WebMvcConfigurer {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE");
        }
    }

Complete API Summary
--------------------

.. list-table::
   :header-rows: 1

   * - Endpoint
     - Methods
     - Description
   * - ``/``
     - GET
     - API info
   * - ``/auth/login``
     - POST
     - User login
   * - ``/user``
     - GET, POST
     - List/Create users
   * - ``/user/{id}``
     - GET, PUT, DELETE
     - User operations
   * - ``/product``
     - GET, POST
     - List/Create products
   * - ``/product/{id}``
     - GET, PUT, DELETE
     - Product operations
   * - ``/category``
     - GET, POST
     - List/Create categories
   * - ``/category/{id}``
     - GET, PUT, DELETE
     - Category operations
   * - ``/order``
     - GET, POST
     - List/Create orders
   * - ``/order/{id}``
     - GET, PUT, DELETE
     - Order operations
   * - ``/order/user/{userId}``
     - GET
     - User orders
   * - ``/order-item``
     - GET, POST
     - List/Create items
   * - ``/chat``
     - POST
     - AI chat stream

Next Steps
----------

* :doc:`backend-services` - Business logic implementation
* :doc:`backend-ai-integration` - AI chat details
