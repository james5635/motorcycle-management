// Container + BoxDecoration
// ClipRRect
// Card

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motorcycle_management/config.dart';
import 'package:motorcycle_management/controller/cart_controller.dart';
import 'package:motorcycle_management/controller/favorites_controller.dart';

// --- 1. Product Grid Screen ---
class ProductGridScreen extends StatefulWidget {
  const ProductGridScreen({super.key});

  @override
  State<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<dynamic> _products = [];
  
  Future<void> _fetchProduct() async {
    var response = await http.get(Uri.parse("${config['apiUrl']}/product"));
    _products = jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: FutureBuilder(
        future: _fetchProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                var response = await http.get(
                  Uri.parse("${config['apiUrl']}/product"),
                );
                setState(() {
                  _products = jsonDecode(response.body);
                });
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) =>
                    ProductCard(product: _products[index]),
              ),
            );
          }
        },
      ),
    );
  }
}

// --- Grid Item Widget ---
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(
            255,
            255,
            255,
            255,
          ), // Background color of the container
          border: Border.all(
            // Defines the border
            color: const Color.fromARGB(255, 199, 199, 199), // Border color
            width: 1, // Border width
          ),
          borderRadius: BorderRadius.circular(10), // Rounds all corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: product["name"], // The animation "anchor"
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            "${config['apiUrl']}/uploads/${product["imageUrl"]}",
                          ),
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "\$${formatPrice(product["price"])}",
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. Product Detail Screen ---
class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = "10";
  final FavoritesController _favoritesController = FavoritesController();

  @override
  void initState() {
    super.initState();
    _favoritesController.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _favoritesController.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: widget.product["name"],
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(30),
                          ),
                          child: Image.network(
                            "${config['apiUrl']}/uploads/${widget.product["imageUrl"]}",
                            height: 450,
                            width: double.infinity,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _circleButton(
                                Icons.arrow_back,
                                () => Navigator.pop(context),
                              ),
                              _circleButton(
                                _favoritesController.isFavorite(widget.product)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                () {
                                  _favoritesController.toggleFavorite(
                                    widget.product,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _favoritesController.isFavorite(
                                              widget.product,
                                            )
                                            ? "Added to favorites!"
                                            : "Removed from favorites!",
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                iconColor:
                                    _favoritesController.isFavorite(
                                      widget.product,
                                    )
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product["name"],
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "\$${formatPrice(widget.product["price"])}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ...List.generate(
                              calculateStars(widget.product["price"]),
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 22,
                              ),
                            ),
                            // const SizedBox(width: 4),
                            // Text(
                            //   // "${widget.product.rating} ",
                            //   "",
                            //   style: const TextStyle(
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 16,
                            //   ),
                            // ),
                            // Text(
                            //   // "( ${widget.product.reviews} Review)",
                            //   "(  Review)",
                            //   style: const TextStyle(color: Colors.grey),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.product["description"],
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      CartController().addToCart(widget.product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Added to cart!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Buy Now",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () => _showSpecsDialog(context),
                  child: Container(
                    height: 60,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(Icons.info_outline, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap, {Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.black),
      ),
    );
  }

  void _showSpecsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Specifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: FutureBuilder(
          future: (() async {
            var response = await http.get(
              Uri.parse("${config['apiUrl']}/category"),
            );
            var categories = jsonDecode(response.body);
            var categoryName = "Unknown";
            var categoryId = widget.product["category"]["categoryId"];
            for (var cat in categories) {
              if (cat["categoryId"] == categoryId) {
                categoryName = cat["name"];
                break;
              }
            }
            return categoryName;
          })(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            String categoryName = snapshot.data ?? "Unknown";

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSpecRow("Category", categoryName),
                  _buildSpecRow("Name", widget.product["name"] ?? "N/A"),
                  _buildSpecRow("Brand", widget.product["brand"] ?? "N/A"),
                  _buildSpecRow(
                    "Model Year",
                    widget.product["modelYear"]?.toString() ?? "N/A",
                  ),
                  _buildSpecRow(
                    "Engine",
                    "${widget.product["engineCc"] ?? "N/A"} CC",
                  ),
                  _buildSpecRow("Color", widget.product["color"] ?? "N/A"),
                  _buildSpecRow(
                    "Condition",
                    widget.product["conditionStatus"] ?? "N/A",
                  ),
                  _buildSpecRow(
                    "Stock",
                    widget.product["stockQuantity"]?.toString() ?? "N/A",
                  ),
                  _buildSpecRow(
                    "Added Date",
                    _formatDate(
                      widget.product["createdAt"] ??
                          widget.product["addedDate"],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }
}
