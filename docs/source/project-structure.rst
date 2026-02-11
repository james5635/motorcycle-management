Project Structure
=================

Directory Layout
----------------

.. code-block:: text

   lib/
   ├── controller/           # State management
   │   ├── cart_controller.dart
   │   └── favorites_controller.dart
   ├── tab/                  # Screen implementations
   │   ├── home.dart
   │   ├── motorcycle.dart
   │   ├── upload.dart
   │   ├── chat.dart
   │   ├── setting.dart
   │   ├── cart_screen.dart
   │   ├── favorites_screen.dart
   │   └── edit_profile.dart
   ├── config.dart          # API config and utilities
   ├── home.dart            # Main navigation
   ├── login.dart           # Login screen
   ├── main.dart            # App entry point
   ├── start.dart           # Landing page
   └── user.dart            # Registration screen

Key Files
---------

**main.dart**

App entry point with MaterialApp and route definitions.

**config.dart**

* ``config`` map with API URL
* ``formatPrice()`` utility
* ``calculateStars()`` utility
* ``faq`` list for settings

**home.dart**

Main scaffold with:

* BottomNavigationBar (5 tabs)
* IndexedStack for tab content
* User data passed to screens

**controller/cart_controller.dart**

Singleton controller for cart state:

* ``addToCart()``
* ``removeFromCart()``
* ``updateQuantity()``
* ``clearCart()``
* ``items`` getter
* ``totalAmount`` getter
* ``itemCount`` getter

**controller/favorites_controller.dart**

Singleton controller for favorites:

* ``addToFavorites()``
* ``removeFromFavorites()``
* ``toggleFavorite()``
* ``isFavorite()``
* ``favorites`` getter

**tab/home.dart**

Home tab with:

* Search bar
* Promo carousel (auto-scroll)
* Categories row
* Featured products
* Most popular products
* Recommended grid

**tab/motorcycle.dart**

Product browsing:

* ``ProductGridScreen`` - 2-column grid
* ``ProductCard`` - Product display
* ``ProductDetailScreen`` - Details with hero animation
* ``_showSpecsDialog`` - Specifications popup

**tab/upload.dart**

Product upload form:

* Image picker
* Text fields (name, brand, price, etc.)
* Category dropdown
* Condition dropdown
* Multipart upload

**tab/chat.dart**

AI chat with:

* Message list
* Text input
* SSE streaming
* Markdown rendering
* Copy/like/dislike buttons

**tab/setting.dart**

Settings screen with:

* User profile header
* Edit profile
* Change password
* My favorites
* My orders
* FAQ
* Terms
* Logout

**tab/cart_screen.dart**

Shopping cart UI:

* Cart items list
* Quantity controls
* Remove items
* Total amount
* Checkout button

**tab/favorites_screen.dart**

Favorites grid:

* 2-column grid of favorites
* Remove button
* Empty state

**tab/edit_profile.dart**

Profile editing:

* Form with validation
* Image picker
* Multipart upload

Platform Directories
--------------------

**android/** - Android configuration

* ``app/src/main/AndroidManifest.xml``
* ``app/build.gradle``

**ios/** - iOS configuration

* ``Runner/Info.plist``
* ``Podfile``

Configuration Files
-------------------

**pubspec.yaml**

Dependencies and app metadata:

* Flutter SDK: ^3.8.1
* http: ^1.6.0
* image_picker: ^1.2.1
* flutter_client_sse: ^2.0.3
* markdown_widget: ^2.3.2+8
* bcrypt: ^1.2.0
* http_parser: ^4.1.2
