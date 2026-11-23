import 'package:flutter/material.dart';

import '../services/auth_service.dart';

/// Mostra os dados do usuário que estão salvos no SharedPreferences.
class PerfilScreen extends StatelessWidget {
  static const rota = '/perfil';

  const PerfilScreen({super.key});

  String _formatarData(DateTime data) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    return '${doisDigitos(data.day)}/${doisDigitos(data.month)}/${data.year} '
        '${doisDigitos(data.hour)}:${doisDigitos(data.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AuthService.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu perfil')),
      body: usuario == null
          ? const Center(child: Text('Nenhum usuário logado.'))
          : ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Nome'),
                  subtitle: Text(usuario.nome),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('E-mail'),
                  subtitle: Text(usuario.email),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Cadastrado em'),
                  subtitle: Text(_formatarData(usuario.criadoEm)),
                ),
                ListTile(
                  leading: const Icon(Icons.fingerprint),
                  title: const Text('ID (uid)'),
                  subtitle: Text(usuario.uid),
                ),
              ],
            ),
    );
  }
}
