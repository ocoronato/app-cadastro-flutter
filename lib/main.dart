import 'package:flutter/material.dart';

import 'screens/cadastro_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/perfil_screen.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  // Necessário antes de usar plugins (como o SharedPreferences) no main.
  WidgetsFlutterBinding.ensureInitialized();

  // Descobre se o usuário continua logado desde a última vez.
  await AuthService.instance.carregarSessao();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final logado = AuthService.instance.currentUser != null;

    return MaterialApp(
      title: 'App Cadastro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      // Logado: abre direto na tela principal. Senão: tela de login.
      initialRoute: logado ? HomeScreen.rota : LoginScreen.rota,
      routes: {
        LoginScreen.rota: (_) => const LoginScreen(),
        CadastroScreen.rota: (_) => const CadastroScreen(),
        HomeScreen.rota: (_) => const HomeScreen(),
        PerfilScreen.rota: (_) => const PerfilScreen(),
      },
    );
  }
}
