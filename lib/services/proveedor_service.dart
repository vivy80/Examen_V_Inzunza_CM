import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/proveedor_model.dart';

class ProviderService {
  final String _baseUrl = "143.198.118.203:8100";
  final String _user = "test";
  final String _pass = "test2023";

  String get _basicAuth => 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';
  Map<String, String> get _headers => {
        'authorization': _basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      };

  Future<List<ProviderModel>> getProviders() async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_list_rest/');
    return await _makeRequest<List<ProviderModel>>(
      url,
      (data) {
        final decodedData = json.decode(data);
        final providerResponse = ProviderResponse.fromJson(decodedData);
        return providerResponse.proveedoresListado;
      },
    );
  }

  Future<bool> addProvider(ProviderModel provider) async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_add_rest/');
    return await _makeRequest<bool>(
      url,
      (data) {
        return true;
      },
      body: provider.toJsonForAdd(),
    );
  }

  Future<bool> editProvider(ProviderModel provider) async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_edit_rest/');
    return await _makeRequest<bool>(
      url,
      (data) {
        return true;
      },
      body: provider.toJson(),
    );
  }

  Future<bool> deleteProvider(int providerId) async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_del_rest/');
    return await _makeRequest<bool>(
      url,
      (data) {
        return true;
      },
      body: {'provider_id': providerId},
    );
  }

  Future<T> _makeRequest<T>(Uri url, T Function(String data) onSuccess, {Map<String, dynamic>? body}) async {
    try {
      final response = await (body == null
          ? http.get(url, headers: _headers)
          : http.post(url, headers: _headers, body: json.encode(body)));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return onSuccess(response.body);
      } else {
        debugPrint('Error ${response.statusCode}: ${response.body}');
        return _handleError<T>(response.statusCode, response.body);
      }
    } catch (e) {
      debugPrint('Exception caught: $e');
      return _handleError<T>(-1, e.toString());
    }
  }

  T _handleError<T>(int statusCode, String message) {
    debugPrint('Handling error with status code $statusCode: $message');
    return statusCode == -1 ? null as T : false as T;
  }
}
