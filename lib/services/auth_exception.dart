/// Erro de autenticação.
///
/// Imita a `FirebaseAuthException`: tem um [code] com os mesmos códigos que
/// o Firebase usa (ex.: `email-already-in-use`, `wrong-password`) e uma
/// [mensagem] em português para mostrar na tela.
class AuthException implements Exception {
  final String code;

  const AuthException(this.code);

  String get mensagem {
    switch (code) {
      case 'email-already-in-use':
        return 'Já existe uma conta com este e-mail.';
      case 'invalid-email':
        return 'O e-mail informado não é válido.';
      case 'weak-password':
        return 'A senha precisa ter pelo menos 6 caracteres.';
      case 'user-not-found':
        return 'Não encontramos uma conta com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta.';
      default:
        return 'Ocorreu um erro. Tente novamente.';
    }
  }

  @override
  String toString() => 'AuthException($code): $mensagem';
}
