/// Modelo do usuário.
///
/// Os campos seguem o modelo `User` do Firebase Auth (uid, email,
/// displayName, metadata.creationTime) para que, quando o app passar a usar
/// o Firebase de verdade, a troca seja simples.
class Usuario {
  /// Identificador único (no Firebase: `user.uid`).
  final String uid;

  /// Nome exibido (no Firebase: `user.displayName`).
  final String nome;

  /// E-mail usado no login (no Firebase: `user.email`).
  final String email;

  /// Data do cadastro (no Firebase: `user.metadata.creationTime`).
  final DateTime criadoEm;

  const Usuario({
    required this.uid,
    required this.nome,
    required this.email,
    required this.criadoEm,
  });

  /// Converte para Map, para poder virar JSON e ser salvo no
  /// SharedPreferences (que só guarda texto, número, bool e lista de texto).
  Map<String, dynamic> toMap() => {
    'uid': uid,
    'nome': nome,
    'email': email,
    'criadoEm': criadoEm.toIso8601String(),
  };

  /// Faz o caminho contrário: monta o Usuario a partir do Map salvo.
  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
    uid: map['uid'] as String,
    nome: map['nome'] as String,
    email: map['email'] as String,
    criadoEm: DateTime.parse(map['criadoEm'] as String),
  );
}
