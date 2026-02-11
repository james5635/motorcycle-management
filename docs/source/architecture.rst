Architecture
============

App Structure
-------------

The app uses a simple layered architecture:

.. code-block:: text

   UI Layer (Screens/Widgets)
          ↕
   Controller Layer (ChangeNotifier)
          ↕
   Data Layer (HTTP API)

State Management
----------------

Controllers use Flutter's ``ChangeNotifier``:

* ``CartController`` - Manages shopping cart state
* ``FavoritesController`` - Manages favorites list

Both use the singleton pattern for app-wide state.

Navigation
----------

Named routes defined in ``main.dart``:

.. code-block:: dart

   routes: {
     '/home': (context) => HomePage(),
     '/login': (context) => LoginPage(),
     '/user': (context) => UserPage(),
     '/start': (context) => StartPage(),
   }

Main navigation uses ``IndexedStack`` with 5 tabs managed in ``home.dart``.

Data Flow
---------

.. code-block:: text

   User Action → Controller → API Call
                              ↓
   UI Updates ← notifyListeners() ← Response

API Integration
---------------

All API calls use the ``http`` package with base URL from ``config.dart``:

* GET requests for fetching data
* POST requests with JSON or multipart
* PUT requests for updates
* SSE for chat streaming
