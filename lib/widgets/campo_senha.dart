import 'package:flutter/material.dart';

/// Campo de senha com o botão de "olhinho" para mostrar/esconder o texto.
///
/// É um StatefulWidget porque precisa lembrar se a senha está visível.
class CampoSenha extends StatefulWidget {
  final TextEditingController controller;
  final String rotulo;
  final String? Function(String?) validator;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CampoSenha({
    super.key,
    required this.controller,
    required this.validator,
    this.rotulo = 'Senha',
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  State<CampoSenha> createState() => _CampoSenhaState();
}

class _CampoSenhaState extends State<CampoSenha> {
  bool _escondida = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _escondida,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        labelText: widget.rotulo,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          tooltip: _escondida ? 'Mostrar senha' : 'Esconder senha',
          icon: Icon(_escondida ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _escondida = !_escondida),
        ),
      ),
    );
  }
}
