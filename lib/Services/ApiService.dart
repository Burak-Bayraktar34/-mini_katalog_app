import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mini_app/Model/Product_Model.dart';

class Apiservice {
  Future<Product_Model> fetchProducts() async {
    final response = await http.get(
      Uri.parse("https://www.wantapi.com/products.php"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product_Model.fromJson(data);
    } else {
      throw Exception("Failed to upload products!!");
    }
  }
}
