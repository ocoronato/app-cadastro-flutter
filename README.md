# App Cadastro (Flutter)

Aplicativo com cadastro e login de usuários, construído por etapas.

**Dupla:** NOME DO ALUNO 1 · NOME DO ALUNO 2

## Como rodar

```bash
flutter pub get
flutter run
```

Testes automáticos:

```bash
flutter test
```

## Estrutura

```
lib/
├── main.dart                 # MaterialApp, tema e rotas
├── models/usuario.dart       # modelo do usuário (campos do Firebase User)
├── services/
│   ├── auth_service.dart     # cadastro, login e logout (mesmos nomes do FirebaseAuth)
│   └── auth_exception.dart   # erros com os códigos do Firebase
├── screens/                  # login, cadastro, home (em branco) e perfil
├── utils/validadores.dart    # validação dos campos
└── widgets/
    ├── campo_senha.dart      # campo de senha com mostrar/esconder
    └── menu_lateral.dart     # drawer da tela principal
wiki/                         # páginas da Wiki (histórias de usuário)
```

---

## Etapa 0 — Organização do projeto

**O que foi feito**
- Repositório criado no GitHub.
- README.md como única documentação; cada etapa ganha uma seção aqui.
- Uma tag por etapa (`etapa-1`, `etapa-2`, ...).

---

## Etapa 1 — Base do projeto, login e cadastro

Tag: `etapa-1`

**O que foi feito**
- Projeto Flutter criado (`flutter create`).
- Tela de **login** (e-mail e senha) e tela de **cadastro** (nome, e-mail, senha e confirmar senha).
- Validação dos campos: obrigatórios, formato do e-mail, senha com no mínimo 6 caracteres (regra do Firebase) e confirmação de senha.
- `AuthService` com os mesmos nomes de métodos do Firebase Auth
  (`createUserWithEmailAndPassword`, `signInWithEmailAndPassword`, `signOut`, `currentUser`)
  e erros com os mesmos códigos (`email-already-in-use`, `user-not-found`, `wrong-password`...).
  Nesta etapa os dados ficam só na memória.
- Requisitos levantados como histórias de usuário na Wiki
  (cópia em [`wiki/Historias-de-Usuario.md`](wiki/Historias-de-Usuario.md)).
- Testes em `test/widget_test.dart`.

**Prints**

| Login | Cadastro |
|---|---|
| ![Login](docs/prints/etapa-1/login.png) | ![Cadastro](docs/prints/etapa-1/cadastro.png) |

**Vídeo:** LINK DO YOUTUBE (não listado)

**Declaração de uso de IA**

> PREENCHER COM AS PALAVRAS DA DUPLA. Exemplo do que responder:
> - Usamos IA? Qual? (ex.: Claude)
> - Para quê? (ex.: gerar a estrutura inicial das telas, entender o `Form` e os validators)
> - O que ela sugeriu? (ex.: imitar os nomes de métodos do `FirebaseAuth`; um widget `CampoSenha` reaproveitável)
> - O que nós alteramos ou aprendemos? (ex.: o erro do `pushNamed<String>` com rotas nomeadas e como corrigimos)

---

## Etapa 2 — SharedPreferences e drawer

Tag: `etapa-2`

**O que foi feito**
- Pacote [`shared_preferences`](https://pub.dev/packages/shared_preferences) para salvar o usuário no aparelho.
  - O `Usuario` virou JSON (`toMap` / `fromMap`) e é salvo na chave `usuario`.
  - Só existe **um cadastro por vez**: salvar na mesma chave substitui o cadastro anterior.
  - A senha **não** é salva em texto puro: salvamos o hash SHA-256 (pacote `crypto`) e, no login, comparamos os hashes.
  - A chave `logado` guarda se a sessão está aberta. Ao abrir o app, o `main()` chama `AuthService.instance.carregarSessao()` e decide se abre no login ou na tela principal.
- Só a parte de dentro do `AuthService` mudou; as telas continuaram chamando os mesmos métodos no estilo Firebase.
- **Drawer** (`widgets/menu_lateral.dart`) com nome e e-mail do usuário no topo e as opções Início, Meu perfil, Sobre e Sair (com confirmação).
- **Tela principal em branco** (`screens/home_screen.dart`).
- Tela **Meu perfil** mostrando os dados salvos.
- Novas histórias de usuário na Wiki (HU05 a HU08).
- Testes do `AuthService` com `SharedPreferences.setMockInitialValues` (`test/auth_service_test.dart`).

**Prints**

| Tela principal | Drawer | Meu perfil |
|---|---|---|
| ![Home](docs/prints/etapa-2/home.png) | ![Drawer](docs/prints/etapa-2/drawer.png) | ![Perfil](docs/prints/etapa-2/perfil.png) |

**Vídeo:** LINK DO YOUTUBE (não listado)

**Declaração de uso de IA**

> PREENCHER COM AS PALAVRAS DA DUPLA. Exemplo do que responder:
> - Usamos IA? Qual? Para quê? (ex.: entender como o SharedPreferences salva dados e como montar o Drawer)
> - O que ela sugeriu? (ex.: salvar o hash da senha em vez da senha; `pushNamedAndRemoveUntil` no logout)
> - O que nós alteramos ou aprendemos?
