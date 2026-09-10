# CineFavorite — Documentação

**Tecnologias:** Flutter, Dart, TMDB API e SQLite/SharedPreferences/API própria.

## 1. Descrição

O **CineFavorite** é um aplicativo mobile desenvolvido em Flutter que permite ao usuário pesquisar filmes e séries através da API do **TMDB** e criar uma lista personalizada de favoritos.

O usuário pode realizar pesquisas, visualizar informações dos conteúdos, adicionar ou remover favoritos e, opcionalmente, atribuir avaliações.

## 2. Funcionalidades

* Cadastro de usuário com nome e imagem de perfil;
* Pesquisa de filmes e séries;
* Consumo da API TMDB;
* Visualização de pôsteres e informações;
* Adição de filmes aos favoritos;
* Listagem dos favoritos em formato de galeria;
* Remoção de favoritos;
* Avaliação personalizada dos filmes, opcionalmente.

## 3. API TMDB

O aplicativo utiliza a API REST do TMDB para buscar os conteúdos.

**URL base:**

```text
https://api.themoviedb.org/3
```

**Principais endpoints:**

```text
/search/movie
/search/tv
```

As pesquisas utilizam parâmetros como `query`, `api_key` e `language`.

A resposta da API é recebida em formato **JSON** e convertida para objetos Dart através do modelo `Movie`.

As imagens dos pôsteres são exibidas utilizando o caminho retornado pela API junto à URL de imagens do TMDB.

## 4. Modelagem

O projeto possui uma classe `Movie` responsável por representar os filmes e séries.

Principais atributos:

```text
id
title
posterPath
rating
```

A classe possui métodos `toMap()` e `fromMap()` para facilitar a conversão dos dados utilizados na persistência.

## 5. Persistência

Os filmes favoritos são armazenados utilizando **SQLite, SharedPreferences ou uma API própria**.

O sistema possui operações para:

* Adicionar favoritos;
* Listar favoritos;
* Atualizar avaliações;
* Remover favoritos.

Dessa forma, os favoritos permanecem armazenados mesmo após o aplicativo ser fechado.

## 6. Organização do Projeto

A aplicação é organizada separando suas responsabilidades:

```text
lib/
├── models/
│   └── movie.dart
├── services/
│   ├── tmdb_service.dart
│   └── persistence_service.dart
├── controllers/
├── views/
└── widgets/
```

* **Models:** representam os dados;
* **Views:** responsáveis pelas telas;
* **Controllers:** controlam a lógica da aplicação;
* **Services:** realizam comunicação com API e banco de dados;
* **Widgets:** componentes reutilizáveis da interface.

## 7. Interface

A interface foi desenvolvida pensando em dispositivos móveis.

São utilizados principalmente:

* `GridView` para os favoritos;
* `ListView` para resultados de pesquisa;
* `Image.network` para os pôsteres;
* `SnackBar` para mensagens;
* Indicadores de carregamento durante as requisições.

## 8. Tratamento de Erros

As requisições à API possuem tratamento de exceções utilizando `try/catch` e verificação do código de resposta HTTP.

Em caso de erro de conexão ou nenhum resultado encontrado, o usuário recebe um feedback através da interface.

Também é utilizado **debounce** na pesquisa para evitar requisições excessivas enquanto o usuário digita.

## 9. Fluxo do Aplicativo

```text
Usuário
   ↓
Login/Cadastro
   ↓
Tela Inicial
   ↓
Pesquisa
   ↓
API TMDB
   ↓
Resultados
   ↓
Selecionar filme
   ↓
Adicionar aos favoritos
   ↓
Banco de Dados
   ↓
Galeria de Favoritos
```

## 10. Conclusão

O CineFavorite aplica conceitos de desenvolvimento mobile com Flutter, consumo de APIs REST, manipulação de JSON, persistência de dados e organização arquitetural.

O projeto atende aos principais requisitos da atividade, permitindo pesquisar filmes e séries e manter uma coleção pessoal de conteúdos favoritos.
