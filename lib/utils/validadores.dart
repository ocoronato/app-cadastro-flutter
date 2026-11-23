/// Funções de validação usadas pelos campos dos formulários.
///
/// Cada função devolve `null` quando o valor é válido, ou a mensagem de erro
/// que o `TextFormField` deve mostrar.
class Validadores {
  static final _regexEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? nome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe seu nome.';
    }
    if (valor.trim().length < 3) {
      return 'O nome precisa ter pelo menos 3 letras.';
    }
    return null;
  }

  static String? email(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe seu e-mail.';
    }
    if (!_regexEmail.hasMatch(valor.trim())) {
      return 'E-mail inválido.';
    }
    return null;
  }

  /// O Firebase Auth exige senha com no mínimo 6 caracteres.
  static String? senha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe sua senha.';
    }
    if (valor.length < 6) {
      return 'A senha precisa ter pelo menos 6 caracteres.';
    }
    return null;
  }

  static String? confirmarSenha(String? valor, String senhaOriginal) {
    if (valor == null || valor.isEmpty) {
      return 'Confirme sua senha.';
    }
    if (valor != senhaOriginal) {
      return 'As senhas não são iguais.';
    }
    return null;
  }
}
