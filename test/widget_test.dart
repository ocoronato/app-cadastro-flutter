import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_cadastro/main.dart';
import 'package:app_cadastro/services/auth_service.dart';
import 'package:app_cadastro/utils/validadores.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AuthService.instance.carregarSessao();
  });

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

  testWidgets('cadastro, login, drawer e sair', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Tenta entrar vazio primeiro: aparecem os erros.
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pump();
    expect(find.text('Informe seu e-mail.'), findsOneWidget);

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
    // Os erros da tentativa anterior não podem continuar na tela.
    expect(find.text('Informe seu e-mail.'), findsNothing);
    expect(find.text('Informe sua senha.'), findsNothing);

    await tester.enterText(find.byType(TextFormField).at(1), 'segredo1');
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pumpAndSettle();

    // Entrou na tela principal (em branco) e o drawer mostra o usuário.
    expect(find.widgetWithText(AppBar, 'Início'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Maria Souza'), findsOneWidget);

    // Sai da conta.
    await tester.tap(find.widgetWithText(ListTile, 'Sair'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sair'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
    expect(AuthService.instance.currentUser, isNull);
  });

  testWidgets('login com campos vazios mostra erros', (tester) async {
    await tester.pumpWidget(const App());
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pump();
    expect(find.text('Informe seu e-mail.'), findsOneWidget);
    expect(find.text('Informe sua senha.'), findsOneWidget);
  });
}
