# Mapa de Caridade - TCC em Ciência da Computação

Este repositório contém o código-fonte completo do aplicativo "Mapa de Caridade", desenvolvido como Trabalho de Conclusão de Curso por **Leonardo Caprio Salvioni** no curso de Ciência da Computação da Universidade Paulista (UNIP).

---

## Sobre o Projeto

O "Mapa de Caridade" é um aplicativo móvel multiplataforma (Android e Web) que visa solucionar a dificuldade de conexão entre potenciais doadores e instituições de caridade na cidade de São José do Rio Preto - SP.

O objetivo geral é criar uma plataforma centralizada e confiável que realiza o mapeamento geográfico interativo de organizações filantrópicas, com o propósito de aumentar sua visibilidade, facilitar o engajamento da comunidade e fortalecer a cultura de doação local.

### Funcionalidades Implementadas (Versão 1.0.0)

- **Mapa Interativo:** Visualização de instituições em um mapa baseado no OpenStreetMap.
- **Busca com Autocomplete:** Encontre instituições pelo nome com sugestões em tempo real.
- **Filtro por Categoria:** Refine a busca por áreas de atuação (ex: idosos, animais, crianças).
- **Perfis Detalhados:** Acesse informações completas sobre cada instituição, incluindo missão, fotos, contatos e necessidades atuais.
- **Sistema de Favoritos:** Salve suas instituições preferidas para acesso rápido (armazenamento local, não requer login).

---

## 🛠️ Tecnologias Utilizadas

A pilha tecnológica (Tech Stack) foi escolhida para equilibrar eficiência de desenvolvimento, performance, custo e escalabilidade.

- **Frontend:**
  - **Framework:** [Flutter](https://flutter.dev/) (versão 3.19)
  - **Linguagem:** [Dart](https://dart.dev/)
  - **Gerenciamento de Estado:** `StatefulWidget` (`setState`)
- **Backend (BaaS):**
  - **Plataforma:** [Firebase](https://firebase.google.com/)
  - **Banco de Dados:** Cloud Firestore (NoSQL em tempo real)
  - **Armazenamento de Mídia:** Firebase Storage
- **Mapas e Geolocalização:**
  - **Provedor de Mapas:** [OpenStreetMap](https://www.openstreetmap.org/)
  - **Biblioteca Flutter:** `flutter_map`
- **Armazenamento Local:**
  - **Biblioteca:** `shared_preferences`
- **Controle de Versão:**
  - **VCS:** Git
  - **Hospedagem:** GitHub

---

## 🚀 Como Executar o Projeto

Para clonar e executar este projeto em sua máquina local, siga os passos abaixo.

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.19 ou superior) instalado.
- Um editor de código, como o [VS Code](https://code.visualstudio.com/), com as extensões para Dart e Flutter.
- Uma conta no [Firebase](https://console.firebase.google.com/).

1. Clonar o Repositório

Abra seu terminal e clone este repositório:

```bash
git clone https://github.com/SEU-USUARIO/tcc-mapa-caridade-sao-jose.git
cd tcc-mapa-caridade-sao-jose
```

### 2. Configurar o Backend Firebase

Este projeto requer uma conexão com um projeto Firebase para funcionar.

1.  **Crie um projeto no Firebase:**
    - Acesse o [Firebase Console](https://console.firebase.google.com/).
    - Clique em "Adicionar projeto" e siga as instruções.

2.  **Ative os Serviços:**
    - No painel do seu novo projeto, vá para a seção **Cloud Firestore**, clique em "Criar banco de dados" e inicie em **modo de teste**.
    - Em seguida, vá para a seção **Storage**, clique em "Primeiros passos" e siga as instruções para criar um bucket de armazenamento.

3.  **Conecte o App ao Firebase:**
    - Instale a CLI do Firebase e do FlutterFire, se ainda não tiver:
      ```bash
      npm install -g firebase-tools
      dart pub global activate flutterfire_cli
      ```
    - Faça login no Firebase:
      ```bash
      firebase login
      ```
    - Dentro da pasta do projeto Flutter, execute o comando de configuração. Ele irá listar seus projetos Firebase, selecione o que você acabou de criar.
      ```bash
      flutterfire configure
      ```
    - Este comando irá gerar automaticamente o arquivo `lib/firebase_options.dart` com as chaves do **SEU** projeto. **Este arquivo não está no repositório por motivos de segurança.**

4.  **Popule o Banco de Dados:**
    - No painel do Cloud Firestore, crie manualmente a coleção `instituicoes`.
    - Adicione alguns documentos de exemplo seguindo a estrutura de dados descrita no TCC (Quadro 6) para que o mapa tenha pontos para exibir.

### 3. Instalar as Dependências

Com o projeto aberto no seu editor, instale todas as dependências listadas no `pubspec.yaml`:

```bash
flutter pub get
```

### 4. Executar o Aplicativo

Agora você está pronto para rodar o app em um emulador, navegador ou dispositivo físico.

```bash
flutter run
```

---