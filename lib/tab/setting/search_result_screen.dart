import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motorcycle_management/config.dart';
import 'package:motorcycle_management/tab/setting/motorcycle.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;

  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late Future<List<dynamic>> _searchResultsFuture;

  @override
  void initState() {
    super.initState();
    _searchResultsFuture = _fetchSearchResults();
  }

  Future<List<dynamic>> _fetchSearchResults() async {
    try {
      final response = await http.get(Uri.parse("${config['apiUrl']}/product"));
      if (response.statusCode == 200) {
        final List<dynamic> allProducts = jsonDecode(response.body);
        final query = widget.query.toLowerCase();
        return allProducts.where((product) {
          final name = (product['name'] ?? "").toString().toLowerCase();
          final brand = (product['brand'] ?? "").toString().toLowerCase();
          return name.contains(query) || brand.contains(query);
        }).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(
          "Results for \"${widget.query}\"",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _searchResultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    "No results found for \"${widget.query}\"",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (context, index) =>
                  ProductCard(product: snapshot.data![index]),
            );
          }
        },
      ),
    );
  }
}
