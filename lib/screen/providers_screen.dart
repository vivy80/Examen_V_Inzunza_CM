import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/proveedor_model.dart';
import '../providers/proveedor_provider.dart';

class ProvidersListView extends StatelessWidget {
  const ProvidersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final providersProvider = Provider.of<ProvidersProvider>(context);
    final providers = providersProvider.providers;

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Proveedores')),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${provider.providerName} ${provider.providerLastName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Email: ${provider.providerMail}'),
                  Text('Estado: ${provider.providerState}'),
                  SizedBox(height: 16),
                  // Aquí van los botones debajo de los atributos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.visibility),
                        label: const Text('Ver'),
                        onPressed: () => _showDetailsFullScreenDialog(context, provider),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar'),
                        onPressed: () => _showAddEditProviderDialog(
                          context,
                          provider: provider,
                          providersProvider: providersProvider,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Eliminar'),
                        onPressed: () {
                          // Eliminación directa sin confirmación
                          providersProvider.removeProvider(provider.providerid);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditProviderDialog(
          context,
          providersProvider: providersProvider,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDetailsFullScreenDialog(BuildContext context, ProviderModel provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del Proveedor'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('ID: ${provider.providerid}'),
                Text('Nombre: ${provider.providerName}'),
                Text('Apellido: ${provider.providerLastName}'),
                Text('Email: ${provider.providerMail}'),
                Text('Estado: ${provider.providerState}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEditProviderDialog(
    BuildContext context, {
    ProviderModel? provider,
    required ProvidersProvider providersProvider,
  }) {
    final isEditing = provider != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: provider?.providerName ?? '');
    final lastNameController = TextEditingController(text: provider?.providerLastName ?? '');
    final mailController = TextEditingController(text: provider?.providerMail ?? '');
    final stateController = TextEditingController(text: provider?.providerState ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Proveedor' : 'Nuevo Proveedor'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Nombre', 'Ingrese un nombre'),
                _buildTextField(lastNameController, 'Apellido', 'Ingrese un apellido'),
                _buildTextField(mailController, 'Email', 'Ingrese un email', email: true),
                _buildTextField(stateController, 'Estado', 'Ingrese un estado'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                final newProvider = ProviderModel(
                  providerid: provider?.providerid ?? 0,
                  providerName: nameController.text.trim(),
                  providerLastName: lastNameController.text.trim(),
                  providerMail: mailController.text.trim(),
                  providerState: stateController.text.trim(),
                );

                if (isEditing) {
                  providersProvider.updateProvider(newProvider);
                } else {
                  providersProvider.createProvider(newProvider);
                }

                Navigator.of(context).pop();
              },
              child: Text(isEditing ? 'Guardar Cambios' : 'Agregar Proveedor'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String errorMsg, {
    bool email = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return errorMsg;
          if (email && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Email inválido';
          return null;
        },
      ),
    );
  }
}


