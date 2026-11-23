import 'package:flutter/material.dart';

import 'screens/cadastro_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Cadastro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: LoginScreen.rota,
      routes: {
        LoginScreen.rota: (_) => const LoginScreen(),
        CadastroScreen.rota: (_) => const CadastroScreen(),
      },
    );
  }
}
