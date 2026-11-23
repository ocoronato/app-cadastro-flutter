import 'package:flutter/material.dart';

import '../widgets/menu_lateral.dart';

/// Tela principal. Por enquanto fica em branco (pedido da Etapa 2);
/// a navegação é feita pelo drawer.
class HomeScreen extends StatelessWidget {
  static const rota = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      // Colocar o drawer no Scaffold já cria o ícone de menu na AppBar.
      drawer: const MenuLateral(),
      body: const SizedBox.shrink(),
    );
  }
}
