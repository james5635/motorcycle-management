var config = {
  // "apiUrl": "http://localhost:8080",
  // "apiUrl": "http://10.0.2.2:8080",
  "apiUrl":
      "https://8080-firebase-motorcycle-1769340866889.cluster-va5f6x3wzzh4stde63ddr3qgge.cloudworkstations.dev",
};

/// Formats a price value, removing trailing .0 for whole numbers
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
