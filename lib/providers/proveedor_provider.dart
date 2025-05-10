import 'package:flutter/material.dart';
import '../models/proveedor_model.dart';
import '../services/proveedor_service.dart';

class ProvidersProvider extends ChangeNotifier {
  final ProviderService _providerService = ProviderService();
  List<ProviderModel> _providers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProviderModel> get providers => _providers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProvidersProvider() {
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    _setLoadingState(true);
    try {
      _providers = await _providerService.getProviders();
      _setLoadingState(false);
    } catch (e) {
      _handleError(e, "fetchProviders");
    }
  }

  Future<bool> createProvider(ProviderModel provider) async {
    _setLoadingState(true);
    bool success = await _performProviderAction(() async {
      return await _providerService.addProvider(provider);
    }, "createProvider");

    if (success) {
      await _loadProviders();
    }
    return success;
  }

  Future<bool> updateProvider(ProviderModel provider) async {
    _setLoadingState(true);
    bool success = await _performProviderAction(() async {
      return await _providerService.editProvider(provider);
    }, "updateProvider");

    if (success) {
      await _loadProviders();
    }
    return success;
  }

  Future<bool> removeProvider(int providerId) async {
    _setLoadingState(true);
    bool success = await _performProviderAction(() async {
      return await _providerService.deleteProvider(providerId);
    }, "removeProvider");

    if (success) {
      _providers.removeWhere((provider) => provider.providerid == providerId);
    }
    return success;
  }

  Future<bool> _performProviderAction(Future<bool> Function() action, String actionName) async {
    bool success = false;
    try {
      success = await action();
    } catch (e) {
      _handleError(e, actionName);
    }
    _setLoadingState(false);
    return success;
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _handleError(Object error, String functionName) {
    _errorMessage = error.toString();
    _providers = [];
    _setLoadingState(false);
    print("Error in $functionName (ProvidersProvider): $error");
  }
}
