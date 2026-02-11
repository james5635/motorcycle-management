Backend Security
================

Security configuration for the Spring Boot backend application.

Overview
--------

The backend uses **Spring Security** for authentication and authorization with the following features:

* BCrypt password hashing
* Session-based authentication
* CSRF protection configuration
* CORS support for frontend access
* H2 console access for development

Security Configuration
----------------------

The main security configuration is in ``SecurityConfig.java``:

.. code-block:: java

    @Configuration
    public class SecurityConfig {

        @Bean
        public PasswordEncoder passwordEncoder() {
            return new BCryptPasswordEncoder(12);
        }

        @Bean
        UserDetailsService userDetailsService(PasswordEncoder encoder) {
            String password = encoder.encode("abc@123");
            UserDetails user = User.withUsername("user")
                .password(password)
                .roles("ADMIN")
                .build();
            return new InMemoryUserDetailsManager(user);
        }

        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) 
                throws Exception {
            http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(authorize -> authorize
                    .anyRequest().permitAll()
                )
                .headers(headers -> headers
                    .frameOptions(FrameOptionsConfig::disable)
                );
            return http.build();
        }
    }

Password Encoding
-----------------

BCrypt Password Hashing
~~~~~~~~~~~~~~~~~~~~~~~

Passwords are hashed using BCrypt with a strength factor of 12:

.. code-block:: java

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }

BCrypt features:

* **Salt generation**: Automatic random salt
* **Adaptive hashing**: Strength factor controls iterations
* **One-way function**: Cannot be decrypted
* **Built-in salt**: Salt is stored with the hash

Usage in Services:

.. code-block:: java

    @Autowired
    private PasswordEncoder encoder;
    
    // Hash password before storing
    String hashedPassword = encoder.encode(plainPassword);
    
    // Verify password during login
    boolean isValid = encoder.matches(plainPassword, hashedPassword);

CSRF Configuration
------------------

CSRF protection is disabled for API endpoints:

.. code-block:: java

    .csrf(csrf -> csrf.disable())

**Note**: In production, consider enabling CSRF with proper token handling for state-changing operations.

Authorization
-------------

Current Configuration
~~~~~~~~~~~~~~~~~~~~~

All requests are permitted (development mode):

.. code-block:: java

    .authorizeHttpRequests(authorize -> authorize
        .anyRequest().permitAll()
    )

Production Configuration
~~~~~~~~~~~~~~~~~~~~~~~~

For production, implement role-based access:

.. code-block:: java

    .authorizeHttpRequests(authorize -> authorize
        // Public endpoints
        .requestMatchers("/auth/**").permitAll()
        .requestMatchers("/product").permitAll()
        .requestMatchers("/category").permitAll()
        
        // Admin only
        .requestMatchers("/user/**").hasRole("ADMIN")
        .requestMatchers(HttpMethod.POST, "/product").hasRole("ADMIN")
        .requestMatchers(HttpMethod.PUT, "/product/**").hasRole("ADMIN")
        .requestMatchers(HttpMethod.DELETE, "/product/**").hasRole("ADMIN")
        
        // Authenticated users
        .requestMatchers("/order/**").authenticated()
        .requestMatchers("/chat").authenticated()
        
        // Deny all others
        .anyRequest().denyAll()
    )

User Roles
~~~~~~~~~~

Default roles in the application:

* **customer**: Standard user role
* **admin**: Administrative privileges

Role is stored in the ``User`` entity:

.. code-block:: java

    @Builder.Default
    private String role = "customer";

H2 Console Security
-------------------

H2 console frame options are disabled for development:

.. code-block:: java

    .headers(headers -> headers
        .frameOptions(FrameOptionsConfig::disable)
    )

This allows the H2 console to be displayed in frames.

Session Management
------------------

Session Configuration
~~~~~~~~~~~~~~~~~~~~~

Session cookie settings in ``application.properties``:

.. code-block:: properties

    server.servlet.session.cookie.same-site=lax

Options for ``same-site``:

* ``strict``: Cookie sent only to same site
* ``lax``: Cookie sent on top-level navigation (default)
* ``none``: Cookie sent with all requests (requires secure)

Session Timeout
~~~~~~~~~~~~~~~

Configure session timeout (in minutes):

.. code-block:: properties

    server.servlet.session.timeout=30m

CORS Configuration
------------------

Cross-Origin Resource Sharing is configured in ``WebConfig.java``:

.. code-block:: java

    @Configuration
    public class WebConfig implements WebMvcConfigurer {
        
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
        }
    }

CORS settings:

* **allowedOrigins**: Frontend URL (``*`` allows all in development)
* **allowedMethods**: HTTP methods permitted
* **allowedHeaders**: Headers allowed in requests
* **allowCredentials**: Allow cookies/auth headers
* **maxAge**: Cache preflight response (seconds)

Security Best Practices
-----------------------

1. **Use HTTPS** in production
2. **Enable CSRF** with proper token handling
3. **Set secure session cookies**:

.. code-block:: properties

    server.servlet.session.cookie.secure=true
    server.servlet.session.cookie.http-only=true

4. **Implement rate limiting** for login endpoints
5. **Use strong BCrypt strength** (12-14)
6. **Validate all input** to prevent injection attacks
7. **Use parameterized queries** (JPA handles this automatically)
8. **Log security events** for monitoring

Production Security Checklist
-----------------------------

.. list-table::
   :header-rows: 1

   * - Item
     - Status
   * - HTTPS enabled
     - [ ]
   * - CSRF enabled
     - [ ]
   * - Session secure flag
     - [ ]
   * - Session http-only flag
     - [ ]
   * - Rate limiting implemented
     - [ ]
   * - Input validation
     - [ ]
   * - SQL injection prevention
     - [ ]
   * - XSS prevention
     - [ ]
   * - Security headers
     - [ ]
   * - Logging enabled
     - [ ]

Authentication Flow
-------------------

Login Process
~~~~~~~~~~~~~

1. **Client sends credentials**:

.. code-block:: 

    POST /auth/login
    {
        "username": "john",
        "password": "secret123"
    }

2. **Server validates**:

.. code-block:: java

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

3. **Session created**: Spring Security manages session
4. **Cookie returned**: Session ID in cookie

Registration Process
~~~~~~~~~~~~~~~~~~~~

1. **Client sends user data**:

.. code-block:: 

    POST /user
    Content-Type: multipart/form-data
    
    user: {"username":"john","email":"john@example.com","password":"secret123",...}
    profileImage: [file]

2. **Server hashes password**:

.. code-block:: java

    String hashedPassword = encoder.encode(dto.password());

3. **User saved** to database
4. **Response** with created user (excluding password)

Security Headers
----------------

Recommended security headers for production:

.. code-block:: java

    http.headers(headers -> headers
        .frameOptions(frameOptions -> frameOptions.deny())
        .xssProtection(xss -> xss.disable())
        .contentSecurityPolicy(csp -> csp.policyDirectives("default-src 'self'"))
        .httpStrictTransportSecurity(hsts -> hsts.includeSubDomains(true).maxAgeInSeconds(31536000))
    );

Next Steps
----------

* :doc:`backend-ai-integration` - AI chat security
* :doc:`backend-deployment` - Production deployment
