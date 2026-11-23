import 'package:flutter/material.dart';

import '../services/auth_exception.dart';
import '../services/auth_service.dart';
import '../utils/validadores.dart';
import '../widgets/campo_senha.dart';
import 'cadastro_screen.dart';

class LoginScreen extends StatefulWidget {
  static const rota = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    // Roda os validators de todos os campos do Form.
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    try {
      final usuario = await AuthService.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );
      if (!mounted) return;
      _mostrarMensagem('Bem-vindo(a), ${usuario.nome}!');
    } on AuthException catch (e) {
      _mostrarMensagem(e.mensagem, erro: true);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _abrirCadastro() async {
    // A tela de cadastro devolve o e-mail criado, para já preencher aqui.
    // Obs.: as rotas do `routes:` são do tipo dynamic, por isso não dá para
    // usar pushNamed<String>; testamos o tipo do resultado com `is String`.
    final emailCriado = await Navigator.pushNamed(
      context,
      CadastroScreen.rota,
    );
    if (emailCriado is String && mounted) {
      _emailController.text = emailCriado;
      _senhaController.clear();
      _mostrarMensagem('Conta criada! Agora faça o login.');
    }
  }

  void _mostrarMensagem(String texto, {bool erro = false}) {
    if (!mounted) return;
    final cores = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(texto),
          backgroundColor: erro ? cores.error : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 96,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Entrar',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      validator: Validadores.email,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CampoSenha(
                      controller: _senhaController,
                      validator: Validadores.senha,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _entrar(),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _carregando ? null : _entrar,
                      child: _carregando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Entrar'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _carregando ? null : _abrirCadastro,
                      child: const Text('Não tem conta? Cadastre-se'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
