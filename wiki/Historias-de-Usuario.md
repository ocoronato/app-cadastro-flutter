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
