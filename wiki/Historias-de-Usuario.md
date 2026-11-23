# Histórias de Usuário

Levantamento de requisitos do app de cadastro e login.
Referência: autenticação por e-mail e senha do **Firebase Auth**.

## Informações do usuário

| Campo | Obrigatório | Regra | Equivalente no Firebase Auth |
|---|---|---|---|
| Nome | Sim | mínimo 3 letras | `displayName` |
| E-mail | Sim | formato válido, único (não pode repetir) | `email` |
| Senha | Sim | mínimo 6 caracteres | senha do provedor *Email/Password* |
| Confirmar senha | Sim (só no cadastro) | igual à senha | — (validação só na tela) |
| Identificador | Gerado pelo app | único | `uid` |
| Data de cadastro | Gerada pelo app | — | `metadata.creationTime` |

---

## HU01 — Cadastrar conta

**Como** visitante, **quero** criar uma conta com nome, e-mail e senha, **para** poder acessar o app.

**Critérios de aceitação**
- [ ] A tela de cadastro tem os campos Nome, E-mail, Senha e Confirmar senha.
- [ ] Nenhum campo pode ficar vazio.
- [ ] O e-mail precisa ter um formato válido.
- [ ] A senha precisa ter pelo menos 6 caracteres (regra do Firebase).
- [ ] Senha e Confirmar senha precisam ser iguais.
- [ ] Se o e-mail já estiver cadastrado, aparece a mensagem "Já existe uma conta com este e-mail."
- [ ] Depois de cadastrar, o app volta para o login com o e-mail já preenchido.

## HU02 — Entrar no app

**Como** usuário cadastrado, **quero** entrar com meu e-mail e senha, **para** usar o app.

**Critérios de aceitação**
- [ ] A tela de login tem os campos E-mail e Senha.
- [ ] Campos vazios ou e-mail inválido mostram erro embaixo do campo.
- [ ] E-mail não cadastrado mostra "Não encontramos uma conta com este e-mail."
- [ ] Senha errada mostra "Senha incorreta."
- [ ] Com e-mail e senha certos, o usuário entra no app.
- [ ] O botão mostra um indicador de carregamento enquanto confere os dados.

## HU03 — Ver ou esconder a senha

**Como** usuário, **quero** mostrar a senha que estou digitando, **para** conferir se digitei certo.

**Critérios de aceitação**
- [ ] Todo campo de senha tem um botão de "olho".
- [ ] Ao tocar no botão, a senha aparece; tocando de novo, ela volta a ficar escondida.

## HU04 — Ir do login para o cadastro

**Como** visitante, **quero** um link na tela de login para criar conta, **para** não precisar procurar onde me cadastrar.

**Critérios de aceitação**
- [ ] A tela de login tem o link "Não tem conta? Cadastre-se".
- [ ] A tela de cadastro tem o botão de voltar para o login.

## HU05 — Guardar meus dados no aparelho *(Etapa 2)*

**Como** usuário, **quero** que meu cadastro continue salvo quando eu fechar o app, **para** não precisar me cadastrar de novo.

**Critérios de aceitação**
- [ ] Os dados do cadastro são salvos com `shared_preferences`.
- [ ] Só existe um cadastro por vez: um novo cadastro substitui o anterior.
- [ ] A senha não é salva em texto puro (é salvo o hash SHA-256).

## HU06 — Continuar logado *(Etapa 2)*

**Como** usuário, **quero** continuar logado ao abrir o app de novo, **para** não digitar a senha toda vez.

**Critérios de aceitação**
- [ ] Se eu não saí da conta, o app abre direto na tela principal.
- [ ] Se eu saí da conta, o app abre na tela de login.

## HU07 — Navegar pelo menu lateral *(Etapa 2)*

**Como** usuário logado, **quero** um menu lateral (drawer), **para** acessar as partes do app.

**Critérios de aceitação**
- [ ] A tela principal tem um ícone de menu que abre o drawer.
- [ ] O topo do drawer mostra meu nome e e-mail.
- [ ] O drawer tem as opções Início, Meu perfil, Sobre e Sair.
- [ ] A tela principal (Início) fica em branco por enquanto.
- [ ] "Meu perfil" mostra os dados salvos (nome, e-mail e data de cadastro).

## HU08 — Sair da conta *(Etapa 2)*

**Como** usuário logado, **quero** sair da minha conta, **para** que outra pessoa não use o app no meu nome.

**Critérios de aceitação**
- [ ] A opção "Sair" do drawer pede confirmação.
- [ ] Ao confirmar, o app volta para a tela de login e não é possível voltar para a tela principal pelo botão "voltar".
- [ ] O cadastro continua salvo; só a sessão é encerrada.
