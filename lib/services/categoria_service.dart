import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/categoria_model.dart';

class CategoryService {
  final String _baseUrl = "143.198.118.203:8100";
  final String _user = "test";
  final String _pass = "test2023";

  // Codificar las credenciales
  String _getAuthorizationHeader() {
    final credentials = '$_user:$_pass';
    return 'Basic ${base64Encode(utf8.encode(credentials))}';
  }

  // Actualizar el encabezado con la autorización
  final _headers = {
    'Content-Type': 'application/json'
  };

  Future<List<Category>> getCategories() async {
    final url = Uri.http(_baseUrl, '/ejemplos/category_list_rest/');
    final resp = await http.get(url, headers: {..._headers, 'Authorization': _getAuthorizationHeader()});
    if (resp.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(resp.body);
      final List data = jsonData["Listado Categorias"];
      return data.map((e) => Category.fromJson(e)).toList();
    }
    throw Exception('Error al cargar categorías $Exception');
  }


  Future<void> addCategory(String name) async {
    final url = Uri.http(_baseUrl, '/ejemplos/category_add_rest/');
    await http.post(url, headers: {..._headers, 'Authorization': _getAuthorizationHeader()}, body: json.encode({"category_name": name}));
  }

  Future<void> editCategory(Category category) async {
    final url = Uri.http(_baseUrl, '/ejemplos/category_edit_rest/');
    await http.post(url, headers: {..._headers, 'Authorization': _getAuthorizationHeader()}, body: json.encode(category.toJson()));
  }

  Future<void> deleteCategory(int id) async {
    final url = Uri.http(_baseUrl, '/ejemplos/category_del_rest/');
    await http.post(url, headers: {..._headers, 'Authorization': _getAuthorizationHeader()}, body: json.encode({"category_id": id}));
  }
}


