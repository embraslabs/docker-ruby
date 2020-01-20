## Docker Ruby
Docker Ruby é uma imagem [Docker](https://www.docker.com/) criada para ser usada como base de desenvolvimento de aplicações utilizando **Ruby on Rails**.
O objetivo desta imagem é tornar a criação, teste e debug de aplicações rails mais fácil e rápida.

Esta imagem foi desenvolvida pelo time da Embraslabs e tem como objetivo facilitar a entrada de novos desenvolvedores na equipe e permitir, com uso das ferramentas citadas abaixo, uma fácil e melhor utilização do ambiente de desenvolvimento.

### Porque usar
* Para reduzir o tempo de criação e configuração de um ambiente  de forma correta e pronta para o desenvolvimento. Dessa forma, você não precisará se preocupar sobre as dependências do sistema e configuração do mesmo, ficando com mais tempo para focar no desenvolvimento da sua aplicação.
* Fácil replicação do ambiente e adesão de novas pessoas no time, garantindo que todos os envolvidos tenham o mesmo ambiente para criar e testar as aplicações.

### Ferramentas inclusas
- [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug): Adiciona a possibilidade de *debugar* o código passo a passo.

- [awesome_print](https://github.com/awesome-print/awesome_print): É uma biblioteca em Ruby que formata de estiliza, colorindo e identando os objetos Ruby impressos no console. Utilizando em conjunto do Ruby on Rails, os objetos do ActiveRecord também serão estilizados, facilitando a leitura e interpretação dos dados.

- [terminal-table](https://github.com/tj/terminal-table): É uma forma fácil e simples de exibir dados formatados em tabela no terminal interativo do Ruby e no console do Rails.

### Como utilizar

Com o comportamento atual da imagem, ao levantar no container, sem parâmetros e sem um volume anexo com um Gemfile, o terminal deverá ser apresentado. Caso tenha um Gemfile no diretório de trabalho, será instalado as  dependências do projeto e o servidor rails será iniciado.

Você pode criar um novo container utilizando esta imagem de duas formas:

#### Por linha de comando:
Para iniciar o container, através da imagem do DockerHub, execute o seguinte comando:

`docker run -it -v embraslabs:dev-ruby`

### Como contribuir

- Clone o projeto usando ```git clone [GitHub - embraslabs/docker-ruby](https://github.com/embraslabs/docker-ruby.git) ```
- Faça suas alterações (:
- Para testar, gere a imagem do projeto com o comando:
`docker build -t <nome_da_imagem>:<tag> <caminho_do_dockerfile>`

Exemplo:

`docker build -t dev-ruby:2.6.0 .`

- E levante um container para ver se tudo funciona como deveria:

`docker run -it --rm <nome_da_imagem>`

Exemplo:

`docker run  -it --rm dev-ruby`

- Se tudo estiver ok, crie um commit com suas alterações e crie um novo pull request.
