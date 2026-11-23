import '../models/usuario.dart';
import 'auth_exception.dart';

/// Serviço de autenticação por e-mail e senha.
///
/// Os nomes dos métodos são os mesmos do `FirebaseAuth`
/// (`createUserWithEmailAndPassword`, `signInWithEmailAndPassword`,
/// `signOut` e `currentUser`). Assim as telas já ficam prontas para o
/// Firebase: no futuro basta trocar o que acontece dentro deste arquivo.
///
/// Etapa 1: os dados ficam só na memória (somem ao fechar o app).
class AuthService {
  AuthService._();

  /// Uma única instância para o app inteiro (padrão singleton),
  /// igual ao `FirebaseAuth.instance`.
  static final AuthService instance = AuthService._();

  Usuario? _usuarioCadastrado;
  String? _senhaCadastrada;
  Usuario? _usuarioLogado;

  /// Usuário logado no momento, ou `null` se ninguém estiver logado.
  Usuario? get currentUser => _usuarioLogado;

  /// Cria a conta.
  ///
  /// Diferença para o Firebase: lá o usuário já fica logado depois do
  /// cadastro. Aqui escolhemos voltar para a tela de login, para o usuário
  /// confirmar o e-mail e a senha que acabou de criar.
  Future<Usuario> createUserWithEmailAndPassword({
    required String nome,
    required String email,
    required String password,
  }) async {
    final emailNormalizado = email.trim().toLowerCase();

    if (_usuarioCadastrado?.email == emailNormalizado) {
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

    _usuarioCadastrado = usuario;
    _senhaCadastrada = password;
    return usuario;
  }

  /// Faz login conferindo e-mail e senha.
  Future<Usuario> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final emailNormalizado = email.trim().toLowerCase();
    final usuario = _usuarioCadastrado;

    if (usuario == null || usuario.email != emailNormalizado) {
      throw const AuthException('user-not-found');
    }
    if (password != _senhaCadastrada) {
      throw const AuthException('wrong-password');
    }

    _usuarioLogado = usuario;
    return usuario;
  }

  /// Sai da conta.
  Future<void> signOut() async {
    _usuarioLogado = null;
  }
}
