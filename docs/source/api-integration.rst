API Integration
===============

Base URL
--------

From ``lib/config.dart``:

.. code-block:: dart

   String get baseUrl => config['apiUrl']!;

API Endpoints
-------------

Authentication
~~~~~~~~~~~~~~

**POST /auth/login**

.. code-block:: dart

   final response = await http.post(
     Uri.parse('$baseUrl/auth/login'),
     headers: {'Content-Type': 'application/json'},
     body: jsonEncode({
       'username': username,
       'password': password,
     }),
   );

**POST /user** (Registration)

Multipart request:

.. code-block:: dart

   var request = http.MultipartRequest('POST', 
     Uri.parse('$baseUrl/user'));
   
   // JSON part
   request.files.add(
     http.MultipartFile.fromString(
       'user',
       jsonEncode({
         'username': fullName,
         'password': password,
         'email': email,
         'phoneNumber': phone,
         'address': address,
         'role': selectedRole,
       }),
       contentType: http.MediaType('application', 'json'),
     ),
   );
   
   // Image part (optional)
   if (imageFile != null) {
     request.files.add(
       await http.MultipartFile.fromPath(
         'profileImage',
         imageFile.path,
       ),
     );
   }
   
   var response = await request.send();

**PUT /user/{id}** (Update)

Same multipart format as POST.

Products
~~~~~~~~

**GET /product**

.. code-block:: dart

   final response = await http.get(
     Uri.parse('$baseUrl/product'),
   );
   
   if (response.statusCode == 200) {
     return jsonDecode(response.body);
   }

**POST /product** (Upload)

Multipart with product data and image:

.. code-block:: dart

   var request = http.MultipartRequest(
     'POST',
     Uri.parse('$baseUrl/product'),
   );
   
   // Product JSON
   request.files.add(
     http.MultipartFile.fromString(
       'product',
       jsonEncode({
         'categoryId': categoryId,
         'name': name,
         'description': description,
         'price': price,
         'stockQuantity': stock,
         'brand': brand,
         'modelYear': year,
         'engineCc': engine,
         'color': color,
         'conditionStatus': condition,
       }),
       contentType: http.MediaType('application', 'json'),
     ),
   );
   
   // Product image
   request.files.add(
     await http.MultipartFile.fromPath(
       'productImage',
       imageFile.path,
       contentType: MediaType('image', 'jpeg'),
     ),
   );

Categories
~~~~~~~~~~

**GET /category**

.. code-block:: dart

   final response = await http.get(
     Uri.parse('$baseUrl/category'),
   );
   
   // Returns list of categories for dropdown

Orders
~~~~~~

**POST /order**

.. code-block:: dart

   final response = await http.post(
     Uri.parse('$baseUrl/order'),
     headers: {'Content-Type': 'application/json'},
     body: jsonEncode({
       'userId': userId,
       'orderDate': DateTime.now().toIso8601String(),
       'totalAmount': total,
       'status': 'pending',
       'shippingAddress': address,
       'paymentMethod': 'ABA',
     }),
   );

**GET /order/user/{userId}**

.. code-block:: dart

   final response = await http.get(
     Uri.parse('$baseUrl/order/user/$userId'),
   );

Order Items
~~~~~~~~~~~

**POST /orderitem**

.. code-block:: dart

   await http.post(
     Uri.parse('$baseUrl/orderitem'),
     headers: {'Content-Type': 'application/json'},
     body: jsonEncode({
       'orderId': orderId,
       'productId': productId,
       'quantity': quantity,
       'unitPrice': price,
     }),
   );

Chat
~~~~

**POST /chat** (SSE streaming)

.. code-block:: dart

   import 'package:flutter_client_sse/flutter_client_sse.dart';
   
   final stream = SSEClient.subscribeToSSE(
     method: SSERequestType.POST,
     url: '$baseUrl/chat',
     header: {'Content-Type': 'application/json'},
     body: {'prompt': userMessage},
   );
   
   stream.listen(
     (event) {
       if (event.data != '[DONE]') {
         setState(() {
           _response += event.data ?? '';
         });
       }
     },
   );

Error Handling
--------------

Basic pattern used in app:

.. code-block:: dart

   try {
     final response = await http.get(Uri.parse(url));
     
     if (response.statusCode == 200) {
       return jsonDecode(response.body);
     } else {
       throw Exception('Failed: ${response.statusCode}');
     }
   } catch (e) {
     // Show error to user
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Error: $e')),
     );
     return [];
   }

Image URLs
----------

Product images served from:

.. code-block:: dart

   '${config['apiUrl']}/uploads/${product['imageUrl']}'

User profile images:

.. code-block:: dart

   '${config['apiUrl']}/uploads/${user['profileImageUrl']}'
