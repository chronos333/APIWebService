# Chef's Shelf

Aplicativo mobile de receitas desenvolvido em Flutter, com integração ao Firebase para autenticação de usuários e armazenamento de receitas favoritas. O aplicativo permite pesquisar receitas, visualizar seus detalhes e salvar suas favoritas para acessá-las posteriormente.

## Funcionalidades

- **Cadastro de usuários:** criação de conta com e-mail e senha.
- **Login:** autenticação de usuários pelo Firebase Authentication.
- **Recuperação de senha:** solicitação de redefinição de senha por e-mail.
- **Pesquisa de receitas:** busca de receitas utilizando a API TheMealDB.
- **Detalhes das receitas:** visualização de imagens, categorias, ingredientes, quantidades e modo de preparo.
- **Receitas favoritas:** possibilidade de salvar e remover receitas favoritas.
- **Minhas receitas:** listagem das receitas salvas pelo usuário.
- **Sincronização em nuvem:** armazenamento das receitas favoritas no Cloud Firestore.
- **Isolamento de dados:** cada usuário acessa somente as próprias receitas salvas.
- **Logout:** encerramento da sessão autenticada.

## Tecnologias utilizadas

- **Flutter** — desenvolvimento da interface mobile.
- **Dart** — linguagem de programação.
- **Firebase Authentication** — autenticação de usuários.
- **Cloud Firestore** — armazenamento das receitas favoritas.
- **TheMealDB API** — consulta de receitas.
- **HTTP** — comunicação com a API externa.

## Estrutura do projeto

```text
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   └── meal.dart
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── meal_detail_screen.dart
│   └── my_recipes_screen.dart
└── services/
    ├── auth_service.dart
    ├── meal_api_service.dart
    └── recipe_service.dart
```

## Pré-requisitos

Antes de executar o projeto, tenha instalado:

- Flutter SDK.
- Dart SDK compatível com a versão do Flutter.
- Android Studio ou outro ambiente configurado para desenvolvimento Flutter.
- Um dispositivo Android ou emulador.
- Uma conta Google para configurar o projeto Firebase.

##  Como executar

### 1. Clonar o repositório

```bash
git clone URL_DO_SEU_REPOSITORIO
cd chefs_shelf
```

### 2. Instalar as dependências

```bash
flutter pub get
```

### 3. Configurar o Firebase

Configure um projeto no Firebase Console e habilite:

- **Authentication:** provedor de e-mail e senha.
- **Cloud Firestore:** banco de dados para armazenar as receitas favoritas.

Configure o Firebase para o aplicativo Flutter usando o FlutterFire CLI. O projeto deve possuir o arquivo `lib/firebase_options.dart` correspondente à configuração utilizada.

Confira também as regras de segurança do Firestore para garantir que cada usuário acesse apenas os próprios documentos.

### 4. Executar o aplicativo

Verifique se o dispositivo ou emulador está conectado:

```bash
flutter devices
```

Depois, execute:

```bash
flutter run
```

## Segurança dos dados

As receitas favoritas são armazenadas em caminhos associados ao identificador do usuário autenticado:

```text
users/{userId}/recipes/{recipeId}
```

As regras do Cloud Firestore devem validar a autenticação e garantir que o identificador do usuário autenticado corresponda ao `userId` do caminho solicitado.

## Verificação do projeto

Para analisar o código:

```bash
flutter analyze
```

Para executar os testes automatizados:

```bash
flutter test
```

## Gerar APK

Para gerar uma versão de lançamento do aplicativo Android:

```bash
flutter build apk --release
```

O APK será gerado, por padrão, em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## API utilizada

O projeto utiliza a API pública **TheMealDB** para consultar receitas e obter informações como nome, imagem, categoria, ingredientes e instruções de preparo.

Documentação: https://www.themealdb.com/api.php

## Desenvolvedor

Projeto desenvolvido como atividade acadêmica para praticar desenvolvimento mobile com Flutter, integração com APIs e utilização de serviços Firebase.

---

*Chef's Shelf — descubra receitas, organize suas favoritas e tenha suas ideias culinárias sempre à mão.*
