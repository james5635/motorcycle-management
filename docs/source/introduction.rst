Introduction
============

The Motorcycle Shop Management Flutter app provides a complete e-commerce solution for motorcycle browsing and purchasing.

App Overview
------------

This Flutter application connects to a Spring Boot backend API to provide:

* Product browsing by category
* User authentication
* Shopping cart functionality  
* Order placement
* AI-powered chat assistance

Features
--------

* User login and registration with profile images
* Product catalog with categories (Sport, Cruiser, Off-Road, Scooter, Touring)
* Shopping cart with quantity management
* Favorites list
* Product upload with image
* AI chat assistant (SSE streaming)
* Order history and checkout
* Profile editing and password change

Technology Stack
----------------

* **Flutter SDK**: 3.8.1
* **Dart**: ^3.8.1
* **HTTP Package**: ^1.6.0 for API communication
* **Image Picker**: ^1.2.1 for photo uploads
* **Flutter Client SSE**: ^2.0.3 for chat streaming
* **Markdown Widget**: ^2.3.2+8 for chat messages

App Architecture
----------------

File Structure
~~~~~~~~~~~~~~

.. code-block:: text

   lib/
   ├── main.dart              # App entry and routes
   ├── config.dart            # API URL and utilities
   ├── home.dart              # Bottom navigation
   ├── start.dart             # Landing screen
   ├── login.dart             # Login UI
   ├── user.dart              # Registration UI
   ├── controller/
   │   ├── cart_controller.dart
   │   └── favorites_controller.dart
   └── tab/
       ├── home.dart              # Home tab
       ├── motorcycle.dart        # Product grid/details
       ├── upload.dart            # Product upload
       ├── chat.dart              # AI chat
       ├── setting.dart           # Settings/orders
       ├── cart_screen.dart
       ├── favorites_screen.dart
       └── edit_profile.dart

Screens
-------

**Public Screens**

* ``start.dart`` - Landing page with login/register buttons
* ``login.dart`` - Username/password login
* ``user.dart`` - Registration form

**Main App Screens (5 tabs)**

1. **Home** - Search, categories, featured products
2. **Motorcycles** - Product grid with details
3. **Upload** - Add new motorcycle with image
4. **Chat** - AI assistant with streaming responses
5. **Settings** - Profile, orders, FAQ, logout

Controllers
-----------

Two singleton controllers manage app state:

* ``CartController`` - Shopping cart items and total
* ``FavoritesController`` - Favorite products list

API Communication
-----------------

The app communicates with a REST API at the URL configured in ``config.dart``:

.. code-block:: dart

   var config = {
     "apiUrl": "http://10.0.2.2:8080",  // Android emulator
     // "apiUrl": "https://your-api.com",  // Production
   };

Key Endpoints
~~~~~~~~~~~~~

* ``POST /auth/login`` - User login
* ``POST /user`` - User registration
* ``GET /product`` - List products
* ``POST /product`` - Upload product with image
* ``POST /order`` - Create order
* ``GET /order/user/{id}`` - User order history
* ``POST /chat`` - AI chat stream (SSE)

Getting Started
---------------

| See :doc:`quick-start` for quick setup.
| See :doc:`installation` for setup instructions.
