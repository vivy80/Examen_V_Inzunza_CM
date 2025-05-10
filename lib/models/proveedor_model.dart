import 'dart:convert';

ProviderResponse providerResponseFromJson(String str) =>
    ProviderResponse.fromJson(json.decode(str));

String providerResponseToJson(ProviderResponse data) =>
    json.encode(data.toJson());

class ProviderResponse {
  final List<ProviderModel> proveedoresListado;

  const ProviderResponse({
    required this.proveedoresListado,
  });

  factory ProviderResponse.fromJson(Map<String, dynamic> json) {
    return ProviderResponse(
      proveedoresListado: List<ProviderModel>.from(
        json["Proveedores Listado"].map(
          (x) => ProviderModel.fromJson(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Proveedores Listado": proveedoresListado
          .map((provider) => provider.toJson())
          .toList(),
    };
  }
}

class ProviderModel {
  final int providerid;
  final String providerName;
  final String providerLastName;
  final String providerMail;
  final String providerState;

  const ProviderModel({
    required this.providerid,
    required this.providerName,
    required this.providerLastName,
    required this.providerMail,
    required this.providerState,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      providerid: json["providerid"],
      providerName: json["provider_name"],
      providerLastName: json["provider_last_name"],
      providerMail: json["provider_mail"],
      providerState: json["provider_state"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "provider_id": providerid, 
      "provider_name": providerName,
      "provider_last_name": providerLastName,
      "provider_mail": providerMail,
      "provider_state": providerState,
    };
  }

  Map<String, dynamic> toJsonForAdd() {
    return {
      "provider_name": providerName,
      "provider_last_name": providerLastName,
      "provider_mail": providerMail,
      "provider_state": providerState,
    };
  }
}
