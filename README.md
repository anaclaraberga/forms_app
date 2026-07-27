# Forms App

Aplicativo em Flutter desenvolvido para listagem e criação de publicações. 

## Tecnologias e Dependências

- Flutter & Dart;
- flutter_bloc: Gerenciamento de estado com Cubits;
- get_it: Service Locator para Injeção de Dependências;
- fpdart: Manipulação de Either para tratamento de erros;
- dio: Cliente HTTP para comunicação com a API.

### Arquitetura escolhida: Clean Architecture

Divisão das camadas:

- Domain: Onde fica a entidade Post, os contratos dos repositórios e os Use Cases (FetchPosts, CreatePost);
- Data: Onde implementa os contratos definidos pelo domínio. Comunica-se com os Data Sources (APIs/Banco de dados) e converte dados brutos em modelos e entidades;
- Presentation: Onde fica as telas (UI) e gerenciadores de estado (Cubits).

### Gerenciamento de Estado com Cubit
Optei pelo uso do Cubit para o controle das telas (PostListCubit e CreatePostCubit) por uma questão de familiaridade. Pontos positivos do Cubit:

- Previsibilidade: A UI reflete diretamente estados imutáveis (Loading, Success, Error);
- Testabilidade: Permite testar as regras de apresentação e fluxos de telas de forma isolada do ciclo de vida dos widgets.

### Tratamento de Erros com fpdart
Em vez de eu utilizar exceções estilo try/catch genéricos, preferi o tipo Either<Failure, T> do fpdart:

- O lado esquerdo (Left) representa falha/erro mapeado (Failure);
- O lado direito (Right) representa retorno com sucesso (T).

Isso obriga o código a tratar ambos os cenários em tempo de compilação, prevenindo erros inesperados no runtime.

### Injeção de Dependência com GetIt
O repositório, os use cases, o cliente HTTP e os cubits são gerenciados via GetIt:

- Garante o desacoplamento, permitindo trocar implementações de API para testes por exemplo;
- Facilita a reutilização de instâncias como Singleton por toda a aplicação.
