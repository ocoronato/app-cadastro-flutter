import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_cadastro/services/auth_exception.dart';
import 'package:app_cadastro/services/auth_service.dart';

void main() {
  final auth = AuthService.instance;

  setUp(() async {
    // SharedPreferences "falso", em memória, só para os testes.
    SharedPreferences.setMockInitialValues({});
    await auth.carregarSessao();
  });

  test('cadastro fica salvo e o login funciona', () async {
    await auth.createUserWithEmailAndPassword(
      nome: 'Ana',
      email: 'Ana@Email.com',
      password: '123456',
    );
    final usuario = await auth.signInWithEmailAndPassword(
      email: 'ana@email.com',
      password: '123456',
    );
    expect(usuario.nome, 'Ana');
    expect(auth.currentUser?.email, 'ana@email.com');
  });

  test('a senha não é salva em texto puro', () async {
    await auth.createUserWithEmailAndPassword(
      nome: 'Ana',
      email: 'ana@email.com',
      password: '123456',
    );
    final prefs = await SharedPreferences.getInstance();
    final valores = prefs.getKeys().map((k) => prefs.get(k).toString());
    expect(valores.any((v) => v.contains('123456')), isFalse);
  });

  test('novo cadastro substitui o anterior', () async {
    await auth.createUserWithEmailAndPassword(
      nome: 'Ana',
      email: 'ana@email.com',
      password: '123456',
    );
    await auth.createUserWithEmailAndPassword(
      nome: 'Bruno',
      email: 'bruno@email.com',
      password: 'abcdef',
    );

    expect(
      () => auth.signInWithEmailAndPassword(
        email: 'ana@email.com',
        password: '123456',
      ),
      throwsA(
        isA<AuthException>().having((e) => e.code, 'code', 'user-not-found'),
      ),
    );
    final bruno = await auth.signInWithEmailAndPassword(
      email: 'bruno@email.com',
      password: 'abcdef',
    );
    expect(bruno.nome, 'Bruno');
  });

  test('senha errada e e-mail repetido geram erro', () async {
    await auth.createUserWithEmailAndPassword(
      nome: 'Ana',
      email: 'ana@email.com',
      password: '123456',
    );
    expect(
      () => auth.signInWithEmailAndPassword(
        email: 'ana@email.com',
        password: 'errada',
      ),
      throwsA(
        isA<AuthException>().having((e) => e.code, 'code', 'wrong-password'),
      ),
    );
    expect(
      () => auth.createUserWithEmailAndPassword(
        nome: 'Outra Ana',
        email: 'ana@email.com',
        password: '654321',
      ),
      throwsA(
        isA<AuthException>().having(
          (e) => e.code,
          'code',
          'email-already-in-use',
        ),
      ),
    );
  });

  test('continua logado ao reabrir o app, até sair', () async {
    await auth.createUserWithEmailAndPassword(
      nome: 'Ana',
      email: 'ana@email.com',
      password: '123456',
    );
    await auth.signInWithEmailAndPassword(
      email: 'ana@email.com',
      password: '123456',
    );

    await auth.carregarSessao(); // simula abrir o app de novo
    expect(auth.currentUser?.nome, 'Ana');

    await auth.signOut();
    await auth.carregarSessao();
    expect(auth.currentUser, isNull);
  });
}
