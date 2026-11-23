import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/usuario.dart';
import 'auth_exception.dart';

/// Serviço de autenticação por e-mail e senha.
///
/// Os nomes dos métodos são os mesmos do `FirebaseAuth`
/// (`createUserWithEmailAndPassword`, `signInWithEmailAndPassword`,
/// `signOut` e `currentUser`). Assim as telas já ficam prontas para o
/// Firebase: no futuro basta trocar o que acontece dentro deste arquivo.
///
/// Etapa 2: os dados ficam salvos no aparelho com o SharedPreferences.
/// O SharedPreferences é um armazenamento simples de chave/valor, então
/// guardamos só UM cadastro: cada novo cadastro substitui o anterior.
class AuthService {
  AuthService._();

  /// Uma única instância para o app inteiro (padrão singleton),
  /// igual ao `FirebaseAuth.instance`.
  static final AuthService instance = AuthService._();

  // Chaves usadas no SharedPreferences.
  static const _chaveUsuario = 'usuario';
  static const _chaveSenhaHash = 'senha_hash';
  static const _chaveLogado = 'logado';

  Usuario? _usuarioLogado;

  /// Usuário logado no momento, ou `null` se ninguém estiver logado.
  Usuario? get currentUser => _usuarioLogado;

  /// Lê o SharedPreferences ao abrir o app. Se o usuário não saiu da conta
  /// da última vez, ele continua logado (o Firebase também faz isso).
  Future<void> carregarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final logado = prefs.getBool(_chaveLogado) ?? false;
    _usuarioLogado = logado ? _lerUsuario(prefs) : null;
  }

  /// Cria a conta e salva no aparelho, substituindo o cadastro anterior.
  ///
  /// Diferença para o Firebase: lá o usuário já fica logado depois do
  /// cadastro. Aqui escolhemos voltar para a tela de login, para o usuário
  /// confirmar o e-mail e a senha que acabou de criar.
  Future<Usuario> createUserWithEmailAndPassword({
    required String nome,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final emailNormalizado = email.trim().toLowerCase();

    if (_lerUsuario(prefs)?.email == emailNormalizado) {
      throw const AuthException('email-already-in-use');
    }
    if (password.length < 6) {
      throw const AuthException('weak-password');
    }

    final usuario = Usuario(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome.trim(),
      email: emailNormalizado,
      criadoEm: DateTime.now(),
    );

    // Salvar com a mesma chave sobrescreve o valor antigo:
    // é isso que faz o novo cadastro substituir o anterior.
    await prefs.setString(_chaveUsuario, jsonEncode(usuario.toMap()));
    await prefs.setString(_chaveSenhaHash, _hash(password));
    await prefs.setBool(_chaveLogado, false);
    _usuarioLogado = null;
    return usuario;
  }

  /// Faz login conferindo o e-mail e o hash da senha salvos.
  Future<Usuario> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final emailNormalizado = email.trim().toLowerCase();
    final usuario = _lerUsuario(prefs);

    if (usuario == null || usuario.email != emailNormalizado) {
      throw const AuthException('user-not-found');
    }
    if (_hash(password) != prefs.getString(_chaveSenhaHash)) {
      throw const AuthException('wrong-password');
    }

    await prefs.setBool(_chaveLogado, true);
    _usuarioLogado = usuario;
    return usuario;
  }

  /// Sai da conta. O cadastro continua salvo; só a sessão termina.
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveLogado, false);
    _usuarioLogado = null;
  }

  Usuario? _lerUsuario(SharedPreferences prefs) {
    final json = prefs.getString(_chaveUsuario);
    if (json == null) return null;
    return Usuario.fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  /// Nunca salvamos a senha em texto puro: guardamos o hash SHA-256 dela.
  /// No login, calculamos o hash da senha digitada e comparamos os hashes.
  String _hash(String senha) => sha256.convert(utf8.encode(senha)).toString();
}
