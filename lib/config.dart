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

/// Calculate number of stars (1-5) based on sum of price digits
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

  while (sum > 5) {
    sum -= 5;
  }

  return sum;
}

var faq = [
  {
    "question": "What is Motorcycle Shop Management?",
    "answer":
        "Motorcycle Shop Management is a Flutter project that helps you manage your motorcycle shop. It is a mobile application that can be used by both customers and administrators.",
  },
  {
    "question": "How do I create an account?",
    "answer":
        "You can create an account by clicking on the 'Create Account' button on the login page.",
  },
  {
    "question": "How do I login?",
    "answer":
        "You can login by clicking on the 'Login' button on the login page.",
  },
  {
    "question": "How do I logout?",
    "answer":
        "You can logout by clicking on the 'Logout' button on the profile page.",
  },
  {
    "question": "How do I view my orders?",
    "answer":
        "You can view your orders by clicking on the 'My Orders' button on the profile page.",
  },
];
