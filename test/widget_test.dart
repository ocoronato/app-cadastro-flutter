import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_cadastro/main.dart';
import 'package:app_cadastro/utils/validadores.dart';

void main() {
  group('Validadores', () {
    test('e-mail', () {
      expect(Validadores.email(''), isNotNull);
      expect(Validadores.email('abc'), isNotNull);
      expect(Validadores.email('aluno@escola.com'), isNull);
    });

    test('senha precisa de 6 caracteres (regra do Firebase)', () {
      expect(Validadores.senha('12345'), isNotNull);
      expect(Validadores.senha('123456'), isNull);
    });

    test('confirmar senha', () {
      expect(Validadores.confirmarSenha('abc123', 'abc124'), isNotNull);
      expect(Validadores.confirmarSenha('abc123', 'abc123'), isNull);
    });
  });

  testWidgets('cadastro volta para o login e o login funciona', (
    tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Abre a tela de cadastro.
    await tester.tap(find.text('Não tem conta? Cadastre-se'));
    await tester.pumpAndSettle();
    expect(find.text('Criar conta'), findsOneWidget);

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'Maria Souza');
    await tester.enterText(campos.at(1), 'maria@email.com');
    await tester.enterText(campos.at(2), 'segredo1');
    await tester.enterText(campos.at(3), 'segredo1');
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    // Voltou para o login com o e-mail preenchido.
    expect(find.text('Conta criada! Agora faça o login.'), findsOneWidget);
    expect(find.text('maria@email.com'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'segredo1');
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pumpAndSettle();
    expect(find.text('Bem-vindo(a), Maria Souza!'), findsOneWidget);
  });

  testWidgets('login com campos vazios mostra erros', (tester) async {
    await tester.pumpWidget(const App());
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pump();
    expect(find.text('Informe seu e-mail.'), findsOneWidget);
    expect(find.text('Informe sua senha.'), findsOneWidget);
  });
}
