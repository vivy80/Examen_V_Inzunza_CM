import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/screen.dart';

class AppRoutes {
  static const initialRoute = 'login';
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'list': (BuildContext context) => const ProductListScreen(),  
    'home': (BuildContext context) => const HomeScreen(), 
    'category': (BuildContext context) => const CategoryScreen(),
    'provider': (BuildContext context) => const ProvidersListView(),
    
  };


  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return const ErrorScreen();
      },
    );
  }
}

