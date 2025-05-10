import 'package:flutter_application_1/theme/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla de Inicio'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal), // Cambiar por el color del tema
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Salir'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
          children: [
            _buildBigButton(
              context,
              icon: Icons.inventory,
              label: 'Ver Productos',
              routeName: 'list',
            ),
            const SizedBox(height: 20),
            _buildBigButton(
              context,
              icon: Icons.category,
              label: 'Ver Categorías',
              routeName: 'category',
            ),
            const SizedBox(height: 20),
            _buildBigButton(
              context,
              icon: Icons.store,
              label: 'Ver Proveedores',
              routeName: 'provider',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigButton(BuildContext context,
      {required IconData icon,
      required String label,
      required String routeName}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyTheme.primary,  // Usar el color del tema
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



