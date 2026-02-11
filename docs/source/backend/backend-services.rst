Backend Services
================

Services contain the business logic and act as an intermediary between controllers and repositories.

Overview
--------

Services use the ``@Service`` annotation and handle:

* Business logic and rules
* Data transformation
* Transaction management
* Integration with repositories
* Password encoding
* Data validation

Service Pattern
---------------

.. code-block:: java

    @Service
    public class ServiceName {
        
        @Autowired
        private RepositoryName repository;
        
        // Business methods
    }

UserService
-----------

Manages user-related business logic including authentication.

.. code-block:: java

    @Service
    public class UserService {
        
        @Autowired
        private UserRepository userRepository;
        
        @Autowired
        private PasswordEncoder encoder;

        public User createUser(CreateUserDto dto, String filename) {
            User user = User.builder()
                .fullName(dto.username())
                .email(dto.email())
                .passwordHash(encoder.encode(dto.password()))
                .phoneNumber(dto.phoneNumber())
                .address(dto.address())
                .role(dto.role())
                .profileImageUrl(filename)
                .build();
            return userRepository.save(user);
        }

        public List<User> getAllUser() {
            return (List<User>) userRepository.findAll();
        }

        public User getUser(long id) {
            return userRepository.findById(id).get();
        }

        public User updateUser(long id, UpdateUserDto dto) {
            User user = userRepository.findById(id).get();
            
            if (dto.username().isPresent()) {
                user.setFullName(dto.username().get());
            }
            if (dto.email().isPresent()) {
                user.setEmail(dto.email().get());
            }
            if (dto.password().isPresent()) {
                user.setPasswordHash(encoder.encode(dto.password().get()));
            }
            if (dto.phoneNumber().isPresent()) {
                user.setPhoneNumber(dto.phoneNumber().get());
            }
            if (dto.address().isPresent()) {
                user.setAddress(dto.address().get());
            }
            if (dto.role().isPresent()) {
                user.setRole(dto.role().get());
            }
            if (dto.profileImageUrl().isPresent()) {
                user.setProfileImageUrl(dto.profileImageUrl().get());
            }
            
            return userRepository.save(user);
        }

        public void deleteUser(long id) {
            userRepository.deleteById(id);
        }

        public ResponseEntity<?> loginUser(String username, String password) {
            User user = userRepository.findByFullName(username);
            
            if (user == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Invalid username"));
            }
            
            if (!encoder.matches(password, user.getPasswordHash())) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Invalid password"));
            }
            
            return ResponseEntity.ok(Map.of("userId", user.getUserId()));
        }

        public long count() {
            return userRepository.count();
        }
    }

**Key Methods**

.. list-table::
   :header-rows: 1

   * - Method
     - Description
   * - ``createUser``
     - Hash password and save new user
   * - ``getAllUser``
     - Retrieve all users
   * - ``getUser``
     - Get user by ID
   * - ``updateUser``
     - Update user fields selectively
   * - ``deleteUser``
     - Remove user by ID
   * - ``loginUser``
     - Authenticate and return user ID
   * - ``count``
     - Get total user count

ProductService
--------------

Manages product catalog operations.

**Key Methods**:

.. list-table::
   :header-rows: 1

   * - Method
     - Description
   * - ``createProduct``
     - Create new product with category
   * - ``getAllProduct``
     - List all products
   * - ``getProduct``
     - Get product by ID
   * - ``getProductByCategory``
     - Filter products by category
   * - ``updateProduct``
     - Update product fields
   * - ``deleteProduct``
     - Remove product

**Example Implementation**:

.. code-block:: java

    public Product createProduct(CreateProductDto dto, String filename) {
        Category category = categoryRepository.findById(dto.categoryId())
            .orElseThrow();
        
        Product product = Product.builder()
            .category(category)
            .name(dto.name())
            .description(dto.description())
            .price(dto.price())
            .stockQuantity(dto.stockQuantity())
            .imageUrl(filename)
            .brand(dto.brand())
            .modelYear(dto.modelYear())
            .engineCc(dto.engineCc())
            .color(dto.color())
            .conditionStatus(dto.conditionStatus())
            .build();
        
        return productRepository.save(product);
    }

CategoryService
---------------

Manages product categories.

**Key Methods**:

.. list-table::
   :header-rows: 1

   * - Method
     - Description
   * - ``createCategory``
     - Create new category
   * - ``getAllCategory``
     - List all categories
   * - ``getCategory``
     - Get category by ID
   * - ``updateCategory``
     - Update category
   * - ``deleteCategory``
     - Remove category

OrderService
------------

Handles order processing and management.

**Key Methods**:

.. list-table::
   :header-rows: 1

   * - Method
     - Description
   * - ``createOrder``
     - Create new order with user
   * - ``getAllOrder``
     - List all orders
   * - ``getOrder``
     - Get order by ID
   * - ``getOrderByUser``
     - Get orders for specific user
   * - ``updateOrder``
     - Update order details
   * - ``deleteOrder``
     - Remove order

OrderItemService
----------------

Manages individual items within orders.

**Key Methods**:

.. list-table::
   :header-rows: 1

   * - Method
     - Description
   * - ``createOrderItem``
     - Add item to order
   * - ``getAllOrderItem``
     - List all order items
   * - ``getOrderItem``
     - Get item by ID
   * - ``getOrderItemByOrder``
     - Get items for specific order
   * - ``updateOrderItem``
     - Update item details
   * - ``deleteOrderItem``
     - Remove item from order

DTOs (Data Transfer Objects)
----------------------------

DTOs define the structure of request data.

CreateUserDto
~~~~~~~~~~~~~

.. code-block:: java

    public record CreateUserDto(
        String username,
        String email,
        String password,
        String phoneNumber,
        String address,
        String role
    ) {}

UpdateUserDto
~~~~~~~~~~~~~

Uses ``Optional`` for partial updates:

.. code-block:: java

    public record UpdateUserDto(
        Optional<String> username,
        Optional<String> email,
        Optional<String> password,
        Optional<String> phoneNumber,
        Optional<String> address,
        Optional<String> role,
        Optional<String> profileImageUrl
    ) {
        public UpdateUserDto withProfileImageUrl(String filename) {
            return new UpdateUserDto(
                username, email, password, phoneNumber, 
                address, role, Optional.of(filename)
            );
        }
    }

CreateProductDto
~~~~~~~~~~~~~~~~

.. code-block:: java

    public record CreateProductDto(
        Long categoryId,
        String name,
        String description,
        BigDecimal price,
        Integer stockQuantity,
        String brand,
        Integer modelYear,
        Integer engineCc,
        String color,
        String conditionStatus,
        LocalDateTime createdAt
    ) {}

CreateOrderDto
~~~~~~~~~~~~~~

.. code-block:: java

    public record CreateOrderDto(
        Long userId,
        BigDecimal totalAmount,
        String shippingAddress,
        String paymentMethod,
        List<CreateOrderItemDto> items
    ) {}

CreateOrderItemDto
~~~~~~~~~~~~~~~~~~

.. code-block:: java

    public record CreateOrderItemDto(
        Long productId,
        Integer quantity,
        BigDecimal unitPrice
    ) {}

Repositories
------------

Repositories extend Spring Data JPA's ``CrudRepository``:

.. code-block:: java

    public interface UserRepository extends CrudRepository<User, Long> {
        User findByFullName(String fullName);
    }

    public interface ProductRepository extends CrudRepository<Product, Long> {
        List<Product> findByCategory_CategoryId(Long categoryId);
    }

    public interface OrderRepository extends CrudRepository<Order, Long> {
        List<Order> findByUser_UserId(Long userId);
    }

**Repository Methods**

Spring Data JPA automatically implements:

* ``findAll()`` - Get all entities
* ``findById(id)`` - Get by primary key
* ``save(entity)`` - Create or update
* ``deleteById(id)`` - Delete by ID
* ``count()`` - Count all entities

Custom query methods:

* ``findByFullName`` - Find user by username
* ``findByCategory_CategoryId`` - Find products by category
* ``findByUser_UserId`` - Find orders by user

Password Encoding
-----------------

Services use ``BCryptPasswordEncoder`` for password security:

.. code-block:: java

    @Autowired
    private PasswordEncoder encoder;
    
    // Hash password
    String hashed = encoder.encode(plainPassword);
    
    // Verify password
    boolean matches = encoder.matches(plainPassword, hashedPassword);

BCrypt strength is configured in ``SecurityConfig``:

.. code-block:: java

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12); // strength factor
    }

Transaction Management
----------------------

Spring manages transactions automatically. For complex operations, use ``@Transactional``:

.. code-block:: java

    @Transactional
    public Order createOrderWithItems(CreateOrderDto dto) {
        Order order = createOrder(dto);
        
        for (CreateOrderItemDto itemDto : dto.items()) {
            createOrderItem(order, itemDto);
        }
        
        return order;
    }

Best Practices
--------------

1. **Keep controllers thin** - Move business logic to services
2. **Use DTOs** for request/response data
3. **Handle nulls** with Optional for updates
4. **Hash passwords** before storing
5. **Validate input** before processing
6. **Use specific exceptions** for error handling
7. **Keep services stateless** - No instance variables except dependencies

Next Steps
----------

* :doc:`backend-security` - Security configuration
* :doc:`backend-ai-integration` - AI service integration
