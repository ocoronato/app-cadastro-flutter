import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../screens/perfil_screen.dart';
import '../services/auth_service.dart';

/// Drawer (menu lateral) da tela principal.
class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  Future<void> _sair(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirmou != true) return;

    await AuthService.instance.signOut();
    if (!context.mounted) return;
    // Remove todas as telas da pilha: o botão "voltar" não volta para a home.
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.rota,
      (rota) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AuthService.instance.currentUser;
    final cores = Theme.of(context).colorScheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: cores.primary),
            accountName: Text(usuario?.nome ?? ''),
            accountEmail: Text(usuario?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: cores.onPrimary,
              child: Text(
                (usuario?.nome.isNotEmpty ?? false)
                    ? usuario!.nome[0].toUpperCase()
                    : '?',
                style: TextStyle(fontSize: 32, color: cores.primary),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Início'),
            selected: true,
            // Já estamos no início: só fecha o drawer.
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Meu perfil'),
            onTap: () {
              Navigator.pop(context); // fecha o drawer
              Navigator.pushNamed(context, PerfilScreen.rota);
            },
          ),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: 'App Cadastro',
            applicationVersion: 'Etapa 2',
            child: Text('Sobre'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () => _sair(context),
          ),
        ],
      ),
    );
  }
}
