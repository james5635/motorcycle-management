Controllers
===========

Overview
--------

Two singleton controllers manage app state using ChangeNotifier.

CartController
--------------

File: ``lib/controller/cart_controller.dart``

Purpose: Manage shopping cart items

State
~~~~~

.. code-block:: dart

   final List<Map<String, dynamic>> _items = [];

Methods
~~~~~~~

**addToCart(product)**

Adds product or increments quantity:

.. code-block:: dart

   void addToCart(Map<String, dynamic> product) {
     int index = _items.indexWhere(
       (item) => item['productId'] == product['productId'],
     );
     
     if (index != -1) {
       _items[index]['quantity'] = 
         (_items[index]['quantity'] ?? 1) + 1;
     } else {
       final newProduct = Map<String, dynamic>.from(product);
       newProduct['quantity'] = 1;
       _items.add(newProduct);
     }
     
     notifyListeners();
   }

**removeFromCart(product)**

Removes item completely:

.. code-block:: dart

   void removeFromCart(Map<String, dynamic> product) {
     _items.removeWhere(
       (item) => item['productId'] == product['productId']
     );
     notifyListeners();
   }

**updateQuantity(product, quantity)**

Updates item quantity:

.. code-block:: dart

   void updateQuantity(Map<String, dynamic> product, int quantity) {
     int index = _items.indexWhere(
       (item) => item['productId'] == product['productId'],
     );
     
     if (index != -1) {
       if (quantity <= 0) {
         _items.removeAt(index);
       } else {
         _items[index]['quantity'] = quantity;
       }
       notifyListeners();
     }
   }

**clearCart()**

Removes all items:

.. code-block:: dart

   void clearCart() {
     _items.clear();
     notifyListeners();
   }

Getters
~~~~~~~

.. code-block:: dart

   // List of cart items
   List<Map<String, dynamic>> get items => _items;
   
   // Total quantity of all items
   int get itemCount => _items.fold(
     0,
     (sum, item) => sum + (item['quantity'] as int),
   );
   
   // Total price
   double get totalAmount => _items.fold(0, (sum, item) {
     double price = double.tryParse(item['price'].toString()) ?? 0.0;
     int quantity = item['quantity'] as int;
     return sum + (price * quantity);
   });

Usage
~~~~~

.. code-block:: dart

   class _CartScreenState extends State<CartScreen> {
     final CartController _cartController = CartController();

     @override
     void initState() {
       super.initState();
       _cartController.addListener(() {
         if (mounted) setState(() {});
       });
     }

     @override
     void dispose() {
       _cartController.removeListener(() {});
       super.dispose();
     }
   }

FavoritesController
-------------------

File: ``lib/controller/favorites_controller.dart``

Purpose: Manage favorite products

State
~~~~~

.. code-block:: dart

   final List<Map<String, dynamic>> _favorites = [];

Methods
~~~~~~~

**addToFavorites(product)**

Adds if not already present:

.. code-block:: dart

   void addToFavorites(Map<String, dynamic> product) {
     if (!isFavorite(product)) {
       _favorites.add(Map<String, dynamic>.from(product));
       notifyListeners();
     }
   }

**removeFromFavorites(product)**

.. code-block:: dart

   void removeFromFavorites(Map<String, dynamic> product) {
     _favorites.removeWhere(
       (item) => item['productId'] == product['productId']
     );
     notifyListeners();
   }

**isFavorite(product)**

.. code-block:: dart

   bool isFavorite(Map<String, dynamic> product) {
     return _favorites.any(
       (item) => item['productId'] == product['productId']
     );
   }

**toggleFavorite(product)**

.. code-block:: dart

   void toggleFavorite(Map<String, dynamic> product) {
     if (isFavorite(product)) {
       removeFromFavorites(product);
     } else {
       addToFavorites(product);
     }
   }

**clearFavorites()**

.. code-block:: dart

   void clearFavorites() {
     _favorites.clear();
     notifyListeners();
   }

Getters
~~~~~~~

.. code-block:: dart

   List<Map<String, dynamic>> get favorites => _favorites;
   int get favoriteCount => _favorites.length;

Singleton Pattern
-----------------

Both controllers use singleton pattern:

.. code-block:: dart

   class CartController extends ChangeNotifier {
     static final CartController _instance = 
       CartController._internal();
     
     factory CartController() => _instance;
     
     CartController._internal();
   }

This ensures the same instance is used throughout the app.
