Configuration
=============

API Configuration
-----------------

The ``lib/config.dart`` file contains the API base URL:

.. code-block:: dart

   var config = {
     "apiUrl": "http://10.0.2.2:8080",
   };

Environment URLs
~~~~~~~~~~~~~~~~

* **Android emulator**: ``http://10.0.2.2:8080``
* **iOS simulator**: ``http://localhost:8080``
* **Physical device**: Use your computer's IP (e.g., ``http://192.168.1.100:8080``)
* **Production**: Your deployed API URL

Utility Functions
-----------------

formatPrice
~~~~~~~~~~~

Removes trailing .0 from prices:

.. code-block:: dart

   String formatPrice(dynamic price) {
     if (price == null) return '0';
     double numPrice = price is num
         ? price.toDouble()
         : double.tryParse(price.toString()) ?? 0;
     if (numPrice == numPrice.truncate()) {
       return numPrice.truncate().toString();
     }
     return numPrice.toStringAsFixed(2);
   }

Examples:

* ``formatPrice(1500)`` → ``"1500"``
* ``formatPrice(1500.50)`` → ``"1500.50"``
* ``formatPrice(null)`` → ``"0"``

calculateStars
~~~~~~~~~~~~~~

Calculates star rating (1-5) based on price digit sum:

.. code-block:: dart

   int calculateStars(dynamic price) {
     if (price == null) return 1;
     int sum = 0;
     String priceStr = price is num
         ? price.toInt().toString()
         : (double.tryParse(price.toString()) ?? 0).toInt().toString();

     for (int i = 0; i < priceStr.length; i++) {
       sum += int.tryParse(priceStr[i]) ?? 0;
     }

     if (sum == 0) return 1;
     while (sum > 5) sum -= 5;
     return sum;
   }

FAQ Data
--------

Static FAQ content for the settings screen:

.. code-block:: dart

   var faq = [
     {
       "question": "What is Motorcycle Shop Management?",
       "answer": "Motorcycle Shop Management is a Flutter project...",
     },
     // ... more FAQs
   ];

Dependencies
------------

From ``pubspec.yaml``:

.. code-block:: yaml

   dependencies:
     flutter:
       sdk: flutter
     http: ^1.6.0
     bcrypt: ^1.2.0
     image_picker: ^1.2.1
     http_parser: ^4.1.2
     flutter_client_sse: ^2.0.3
     markdown_widget: ^2.3.2+8
