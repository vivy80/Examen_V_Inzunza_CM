import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/categoria_provider.dart';
import '../models/categoria_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    _loadFuture = provider.loadCategories(); 
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Categorías")),
      body: FutureBuilder(
        future: _loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: provider.categories.length,
            itemBuilder: (_, i) {
              final category = provider.categories[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(category.name),
                      subtitle: Text('Estado: ${category.state}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.visibility),
                            label: const Text('Ver'),
                            onPressed: () => _showCategoryDialog(context, category, readOnly: true),
                          ),
                          const SizedBox(width: 10), 
                          ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text('Editar'),
                            onPressed: () => _showCategoryDialog(context, category),
                          ),
                          const SizedBox(width: 10), // Espacio entre los botones
                          ElevatedButton.icon(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text('Eliminar'),
                            onPressed: () async {
                              await provider.removeCategory(category.id);
                              setState(() {
                                _loadFuture = provider.loadCategories(); // Recarga luego de borrar
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, Category? category, {bool readOnly = false}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final state = category?.state ?? 'Activa';

    showDialog(
      context: context,
      barrierDismissible: !readOnly,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text(
            readOnly
                ? 'Ver Categoría'
                : (category == null ? 'Nueva Categoría' : 'Editar Categoría'),
            style: const TextStyle(fontSize: 18),
          ),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: readOnly,
                ),
              ],
            ),
          ),
          actions: [
            if (!readOnly)
              TextButton(
                onPressed: () async {
                  final provider = Provider.of<CategoryProvider>(context, listen: false);
                  if (category == null) {
                    await provider.addCategory(nameController.text.trim());
                  } else {
                    await provider.updateCategory(Category(
                      id: category.id,
                      name: nameController.text.trim(),
                      state: state,
                    ));
                  }
                  if (buildContext.mounted) {
                    Navigator.of(buildContext).pop();
                    setState(() {
                      _loadFuture = provider.loadCategories();
                    });
                  }
                },
                child: Text(category == null ? 'Agregar' : 'Guardar'),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}


