Backend Entities
================

JPA entity classes define the data model for the Motorcycle Shop Management application.

Overview
--------

The backend uses JPA (Jakarta Persistence API) with Hibernate as the provider. Entities map Java classes to database tables.

Common Annotations
------------------

**Entity Declaration**

.. code-block:: java

    @Entity
    @Table(name = "TableName")
    public class EntityName {
        // fields
    }

**Lombok Annotations**

.. code-block:: java

    @Data                    // Generates getters, setters, toString, equals, hashCode
    @Builder                 // Builder pattern
    @NoArgsConstructor       // Empty constructor
    @AllArgsConstructor      // All-args constructor

**Primary Key**

.. code-block:: java

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

**Column Configuration**

.. code-block:: java

    @Column(nullable = false, length = 100)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(updatable = false)
    private LocalDateTime createdAt;

Entity Relationships
--------------------

**Many-to-One**

.. code-block:: java

    @ManyToOne
    @JoinColumn(name = "foreign_key_column")
    private RelatedEntity related;

User Entity
-----------

Stores user account information.

.. code-block:: java

    @Entity
    @Table(name = "Users")
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public class User {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long userId;

        @Column(nullable = false, length = 100, unique = true)
        private String fullName;

        @Column(unique = true, nullable = false, length = 100)
        private String email;

        @Column(nullable = false)
        private String passwordHash;

        private String phoneNumber;
        
        @Column(columnDefinition = "TEXT")
        private String address;

        @Builder.Default
        private String role = "customer";

        private String profileImageUrl;

        @Builder.Default
        @Column(updatable = false)
        private LocalDateTime createdAt = LocalDateTime.now();
    }

**Fields**

* ``userId``: Primary key, auto-generated
* ``fullName``: Username, unique, required (100 chars max)
* ``email``: Unique, required (100 chars max)
* ``passwordHash``: BCrypt hashed password
* ``phoneNumber``: Optional contact number
* ``address``: Optional, stored as TEXT
* ``role``: User role, defaults to "customer"
* ``profileImageUrl``: Filename of uploaded profile image
* ``createdAt``: Timestamp, set on creation

Product Entity
--------------

Stores motorcycle product information.

.. code-block:: java

    @Entity
    @Table(name = "Products")
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public class Product {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long productId;

        @ManyToOne
        @JoinColumn(name = "category_id")
        private Category category;

        @Column(nullable = false, length = 150)
        private String name;

        @Column(columnDefinition = "TEXT")
        private String description;

        @Column(nullable = false, precision = 10, scale = 2)
        private BigDecimal price;

        @Builder.Default
        private Integer stockQuantity = 0;

        private String imageUrl;
        private String brand;
        private Integer modelYear;
        private Integer engineCc;
        private String color;

        @Builder.Default
        private String conditionStatus = "new";

        @Builder.Default
        @Column(updatable = false)
        private LocalDateTime createdAt = LocalDateTime.now();
    }

**Fields**

* ``productId``: Primary key
* ``category``: Many-to-one relationship with Category
* ``name``: Product name, required (150 chars max)
* ``description``: Optional detailed description (TEXT)
* ``price``: Decimal with 10 digits, 2 decimal places
* ``stockQuantity``: Available quantity, defaults to 0
* ``imageUrl``: Product image filename
* ``brand``: Manufacturer brand
* ``modelYear``: Manufacturing year
* ``engineCc``: Engine displacement in CC
* ``color``: Product color
* ``conditionStatus``: "new" or "used", defaults to "new"
* ``createdAt``: Creation timestamp

Category Entity
---------------

Stores product categories.

.. code-block:: java

    @Entity
    @Table(name = "Categories")
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public class Category {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long categoryId;

        @Column(nullable = false, length = 50)
        private String name;

        @Column(columnDefinition = "TEXT")
        private String description;

        private String imageUrl;
    }

**Fields**

* ``categoryId``: Primary key
* ``name``: Category name, required (50 chars max)
* ``description``: Optional category description
* ``imageUrl``: Category image filename

**Default Categories**

* Sport
* Cruiser
* Off-Road
* Scooter
* Touring

Order Entity
------------

Stores customer orders.

.. code-block:: java

    @Entity
    @Table(name = "Orders")
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public class Order {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long orderId;

        @ManyToOne
        @JoinColumn(name = "user_id", nullable = false)
        private User user;

        @Builder.Default
        private LocalDateTime orderDate = LocalDateTime.now();

        @Column(nullable = false, precision = 10, scale = 2)
        private BigDecimal totalAmount;

        @Builder.Default
        private String status = "pending";

        @Column(nullable = false, columnDefinition = "TEXT")
        private String shippingAddress;

        private String paymentMethod;
    }

**Fields**

* ``orderId``: Primary key
* ``user``: Many-to-one relationship with User (required)
* ``orderDate``: Order creation timestamp
* ``totalAmount``: Order total (decimal)
* ``status``: Order status ("pending", "processing", "shipped", "delivered", "cancelled")
* ``shippingAddress``: Delivery address (required)
* ``paymentMethod``: Payment method used

OrderItem Entity
----------------

Stores individual items within an order.

.. code-block:: java

    @Entity
    @Table(name = "OrderItems")
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public class OrderItem {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long orderItemId;

        @ManyToOne
        @JoinColumn(name = "order_id", nullable = false)
        private Order order;

        @ManyToOne
        @JoinColumn(name = "product_id", nullable = false)
        private Product product;

        @Column(nullable = false)
        private Integer quantity;

        @Column(nullable = false, precision = 10, scale = 2)
        private BigDecimal unitPrice;
    }

**Fields**

* ``orderItemId``: Primary key
* ``order``: Many-to-one relationship with Order
* ``product``: Many-to-one relationship with Product
* ``quantity``: Number of items
* ``unitPrice``: Price per unit at time of order

Entity Diagram
--------------

.. code-block:: text

    +-------------+       +-------------+       +-------------+
    |    User     |       |    Order    |       |  OrderItem  |
    +-------------+       +-------------+       +-------------+
    | PK userId   |<------| FK user_id  |       | PK itemId   |
    | fullName    |       | PK orderId  |<------| FK order_id |
    | email       |       | orderDate   |       | FK productId|
    | passwordHash|       | totalAmount |       | quantity    |
    | role        |       | status      |       | unitPrice   |
    +-------------+       | shippingAddr|       +-------------+
                          +-------------+            |
                                                     |
                          +-------------+            |
                          |   Product   |<-----------+
                          +-------------+
                          | PK productId|
                          | name        |
                          | price       |
                          | FK category |
                          +-------------+
                                |
                                v
                          +-------------+
                          |   Category  |
                          +-------------+
                          | PK category |
                          | name        |
                          +-------------+

Additional Entities
-------------------

Review Entity
~~~~~~~~~~~~~

Stores product reviews (simplified version in codebase).

.. code-block:: java

    @Entity
    public class Review {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long reviewId;
        
        private Integer rating;
        private String comment;
        
        @ManyToOne
        private User user;
        
        @ManyToOne
        private Product product;
    }

Service Entity
~~~~~~~~~~~~~~

Stores service appointments (simplified version).

.. code-block:: java

    @Entity
    public class Service {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long serviceId;
        
        private String serviceType;
        private LocalDateTime appointmentDate;
        private String status;
        
        @ManyToOne
        private User user;
    }

Best Practices
--------------

1. **Always use wrapper types** (Long, Integer) instead of primitives for IDs to allow null
2. **Use @Builder.Default** for default field values when using @Builder
3. **Set upddatable=false** on creation timestamps
4. **Use appropriate column types** (TEXT for long strings, DECIMAL for money)
5. **Add unique constraints** on fields that must be unique
6. **Use nullable=false** for required fields

Next Steps
----------

* :doc:`backend-controllers` - REST API controllers
* :doc:`backend-services` - Business logic layer
