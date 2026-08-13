# Projeto Biblioteca API JSON

## 1. Identificação do Projeto

- **Nome do Projeto**: Biblioteca App
- **Descrição**: Aplicativo móvel multiplataforma (Flutter) para gerenciamento de bibliotecas, com funcionalidades de CRUD ( Criar , Ler, Atualizar, Deletar) para Usuários, Livros e Empréstimos.

## 2. Propósito e Escopo

O Sistema tem como Objetivo digitalizar e simplificar a gestão de acervos bibliotecários. Ele permite o cadastro e controle de livros, usuários e empréstimos, oferencedo uma interface intuitiva para administradores.

O Escopo atual inclui operaçoes básica de gerenciamento de dados persistidos em um backend simulado via json-server.

## 3. Requisitos do Sistema

### 3.1 Requisitos Funcionais (RF)

| ID | Requisito | Descrição |
| - | - | - |
| RF01 | Gerenciar Livros | Listar, Cadastrar, Editar e Excluir livros do acervo |
| RF02 | Gerenciar Usuários | Listar, Cadastrar, Editar e Excluir Usuários do Sistema |
| RF03 | Gerenciar Empréstimos de Livros | Visualizar e gernciar empréstimos de livros |
| RF04 | Navegação | Interface com Navegação por abas ( Livros, Empréstimos, Usuários) |

### 3.2 Requisitos Não Funcionais (RNF)

| ID | Requisito | Descrição |
| - | - | - |
| RNF01 | Arquitetura | Baseada em Camadas ( Model, Service, Controller, View) seguindo o padrão MVC |
| RNF02 | Persistência | Utiliza um arquivo db.json como fonte de dados acessando via APIREST (json-server) |
| RNF03 | Tecnologia | Desenvolvimento em Flutter/Dart, com consumo de Api via pacote http |
| RNF04 | Comuicação | A comunicação com o BackEnd é feita através de requisições HTTP sincronas (GET, POST, PUT, DELETE) |

## 4. EndPoint da API (BackEnd)

