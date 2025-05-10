import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/productos_model.dart';

class ProductService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Listado> products = [];
  Listado? selectProduct;
  bool isLoading = true;
  bool isEditCreate = true;

  ProductService() {
    loadProducts();
  }

  Future loadProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.http(_baseUrl, 'ejemplos/product_list_rest/');
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';
      final response = await http.get(url, headers: {'authorization': basicAuth});

      if (response.statusCode == 200) {
        final productsMap = Product.fromJson(response.body);
        products = productsMap.listado;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print(e);  
    }

    isLoading = false;
    notifyListeners();
  }


  Future editOrCreateProduct(Listado product) async {
    isEditCreate = true;
    notifyListeners();
    
    if (product.productId == 0) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isEditCreate = false;
    notifyListeners();
  }

 
  Future<String> updateProduct(Listado product) async {
    final url = Uri.http(_baseUrl, 'ejemplos/product_edit_rest/');
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';
    
    final response = await http.post(url, body: product.toJson(), headers: {
      'authorization': basicAuth,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      
      final index = products.indexWhere((element) => element.productId == product.productId);
      products[index] = product;
    } else {
      throw Exception('Failed to update product');
    }

    return '';
  }

  
  Future createProduct(Listado product) async {
    final url = Uri.http(_baseUrl, 'ejemplos/product_add_rest/');
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';
    
    final response = await http.post(url, body: product.toJson(), headers: {
      'authorization': basicAuth,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      products.add(product);
    } else {
      throw Exception('Failed to create product');
    }

    return '';
  }

  
  Future deleteProduct(Listado product, BuildContext context) async {
    final url = Uri.http(_baseUrl, 'ejemplos/product_del_rest/');
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';
    
    final response = await http.post(url, body: product.toJson(), headers: {
      'authorization': basicAuth,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      products.clear(); 
      loadProducts();  
      Navigator.of(context).pushNamed('list');
    } else {
      throw Exception('Failed to delete product');
    }

    return '';
  }

  void addProduct(Listado newProduct) {
    products.add(newProduct);
    notifyListeners();
  }
}
