# Quadro-de-Tarefas - App de Gestão de Tarefas

Aplicativo mobile (Android/iOS) desenvolvido em Flutter, inspirado em ferramentas como Trello e Jira. O objetivo é demonstrar habilidades em Flutter, arquitetura limpa e boas práticas de desenvolvimento, focando em um fluxo de trabalho moderno para organização de tarefas.

## ✨ Funcionalidades

- **Quadros e Listas Personalizáveis:** Crie quadros de projetos e listas (ex: "A Fazer", "Em Andamento", "Concluído").
- **Cards de Tarefas:** Adicione, edite e mova tarefas entre listas.
- **Drag & Drop:** Arraste tarefas entre listas de forma intuitiva.
- **Gestão de Tarefas:** Edite títulos e descrições das tarefas.
- **Persistência de Dados (em desenvolvimento):** Estrutura pronta para salvar dados localmente ou em nuvem.

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** Dart
- **Framework:** Flutter
- **Gerenciamento de Estado:** BLoC (`flutter_bloc`, `bloc`)
- **Arquitetura:** Clean Architecture

## 📦 Bibliotecas Externas

- [`flutter_bloc`](https://pub.dev/packages/flutter_bloc): Gerenciamento de estado reativo com BLoC.
- [`equatable`](https://pub.dev/packages/equatable): Facilita comparações de objetos para estados e eventos.
- [`provider`](https://pub.dev/packages/provider): Injeção de dependências e gerenciamento de estado.
- [`uuid`](https://pub.dev/packages/uuid): Geração de identificadores únicos para tarefas e quadros.
- [`shared_preferences`](https://pub.dev/packages/shared_preferences): Persistência simples de dados localmente.
- [`intl`](https://pub.dev/packages/intl): Internacionalização e formatação de datas.
- Outras bibliotecas podem ser utilizadas conforme a necessidade do projeto.

## 📂 Organização dos Arquivos (`lib/`)

- **pages/**  
  Telas principais do app, como a Home Page, onde estão os quadros, listas e cards.
- **models/**  
  Definição das classes de dados, como `BoardModel`, `TaskModel` e `ListModel`.
- **services/**  
  Serviços responsáveis por manipulação de dados, como salvar e carregar quadros/tarefas.
- **blocs/**  
  Implementação do padrão BLoC para gerenciamento de estado e lógica de negócio.
- **widgets/**  
  Componentes reutilizáveis, como cards de tarefas, listas e botões customizados.
- **utils/**  
  Funções utilitárias e helpers para formatação de datas, validações, etc.

## 🧩 Principais Arquivos

- [`lib/pages/home_page.dart`](lib/pages/home_page.dart): Tela principal com visualização dos quadros, listas e tarefas.
- [`lib/models/board_model.dart`](lib/models/board_model.dart): Modelo de dados para quadros.
- [`lib/models/task_model.dart`](lib/models/task_model.dart): Modelo de dados para tarefas.
- [`lib/services/task_service.dart`](lib/services/task_service.dart): Serviço para persistência e manipulação de tarefas.
- [`lib/blocs/`](lib/blocs/): Lógica de estado usando BLoC.

## 🚀 Como Executar

1. Clone o repositório:
    ```sh
    git clone https://github.com/RaimundoNCN/Quadro-de-Tarefas.git
    cd teste
    ```
2. Instale as dependências:
    ```sh
    flutter pub get
    ```
3. Execute o app:
    ```sh
    flutter run
    ```
   (Para rodar em uma plataforma específica: `flutter run -d android` ou `flutter run -d ios`)

## 👨‍💻 Sobre o Projeto

Este projeto foi desenvolvido para portfólio, com foco em arquitetura limpa, separação de responsabilidades e escalabilidade. O uso do padrão BLoC facilita a manutenção e testabilidade do código.

## 📫 Contato

- **GitHub:** [Raimundo NCN](https://github.com/RaimundoNCN)
- **LinkedIn:** [Raimundo Neto](https://www.linkedin.com/in/raimundo-nazareno-concei%C3%A7%C3%A3o-neto-853083195?lipi=urn%3Ali%3Apage%3Ad_flagship3_feed%3BC1qCdofWTe%2BnqQWVZKjkbw%3D%3D)
- **Email:** raimundo.n.neto10@gmail.com

---
Desenvolvido por [RaimundoNCN]