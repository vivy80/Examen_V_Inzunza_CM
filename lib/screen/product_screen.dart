import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/producto_service.dart';
import 'package:flutter_application_1/models/productos_model.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: productService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productService.products.length,
              itemBuilder: (context, index) {
                final product = productService.products[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      // Imagen en la parte superior
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: (product.productImage.isEmpty ||
                                !product.productImage.startsWith('http'))
                            ? Image.asset('assets/no-image.png', fit: BoxFit.cover)
                            : Image.network(
                                product.productImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/no-image.png');
                                },
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Atributos en el medio
                            Text(
                              product.productName,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('\$${product.productPrice}'),
                          ],
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.visibility),
                              label: const Text('Ver'),
                              onPressed: () {
                                _showProductDialog(context, product, readOnly: true);
                              },
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.edit),
                              label: const Text('Editar'),
                              onPressed: () {
                                _showProductDialog(context, product);
                              },
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text('Eliminar'),
                              onPressed: () async {
                                final productService = Provider.of<ProductService>(context, listen: false);
                                await productService.deleteProduct(product, context);
                                await productService.loadProducts(); // Refrescar lista
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newProduct = Listado(
            productId: 0,
            productName: '',
            productPrice: 0,
            productImage: '',
            productState: 'Activo',
          );
          _showProductDialog(context, newProduct);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showProductDialog(BuildContext context, Listado product, {bool readOnly = false}) {
    final nameController = TextEditingController(text: product.productName);
    final priceController = TextEditingController(text: product.productPrice.toString());
    final imageController = TextEditingController(text: product.productImage);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(readOnly
              ? 'Detalle del producto'
              : product.productId == 0
                  ? 'Nuevo producto'
                  : 'Editar producto'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    readOnly: readOnly,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                    readOnly: readOnly,
                    validator: (value) {
                      final parsed = int.tryParse(value ?? '');
                      if (parsed == null || parsed < 0) {
                        return 'Ingrese un precio válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(labelText: 'URL de imagen'),
                    readOnly: readOnly,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      if (!value.startsWith('http')) {
                        return 'La URL debe comenzar con http';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            if (!readOnly)
              TextButton(
                child: const Text('Guardar'),
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  final updatedProduct = product.copy()
                    ..productName = nameController.text
                    ..productPrice = int.tryParse(priceController.text) ?? 0
                    ..productImage = imageController.text;

                  final productService = Provider.of<ProductService>(context, listen: false);
                  await productService.editOrCreateProduct(updatedProduct);
                  await productService.loadProducts(); // Refrescar lista
                  Navigator.of(context).pop();
                },
              ),
          ],
        );
      },
    );
  }
}

