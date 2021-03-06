# web crawler api

Aplicação desenvolvida para vaga Backend na empresa Inovamind. Que realiza uma busca por frases no site [Quotes to Scrape](https://quotes.toscrape.com/) e as disponibiliza em uma API.

## Ferramentas utilizadas
- Framework ruby on rails 
  -   ruby versão 3.0.0p0 
  -   rails versão 6.1.4.6
- Database MongoDB


## Gems utilizadas 
- gem 'mongoid': utilizada para manipulação do banco de dados MongoDB
- gem 'active_model_serializers', '~> 0.10.0': utilizada para gerar um JSON de maneira orientada a objetos e orientada a convenções
- gem 'nokogiri': utilizada para pesquisar, utilizando seletores XPath e CSS3, nós da árvore DOM desejados em um site
- gem 'open-uri': utilizada para acessar o conteúdo publicado na web (html, js, css, etc...)
- gem 'jwt': utilizada para fazer a autenticação via token (JWT)


## Funcionamento
Inicialmenete é necessáiro baixar essa aplicação. Tendo ela em mãos utilize o seguinte comando: 
> rails s

Como essa API é protegida por TOKEN é necessário que antes de qualquer coisa seja feita uma requisição **POST** para o link http://localhost:3000/auths. Informando no **BODY** a estrutura json:
~~~json
{ 
  "name": "Seu nome"
}
~~~

Será então retornado um token de acesso que deve ser usado na autenticação das requisições. Ele deve ser informado no **HEADER**, na key *Authorization*, precedido da palavra **Bearer** de todas as requisições feitas na API. Este token está configurado para expirar após 5 minutos de sua criação, após esse tempo será necessário gerar um novo.

São disponibilizadas 2 tipos de requisições, além da responsável pela autenticação:

- **GET** que utiliza a url http://localhost:3000/quotes/{SEARCH_TAG}. Pode ser acessada por um navegador ou aplicativo para analise de requisições HTTP, onde SEARCH_TAG deve ser substituido por alguma *tag* de sua escolha. Primeiramente a *tag* informada será procurada no banco de dados, caso seja encontrada serão retornadas as frases já presente no memso banco. E caso não seja encontrada será feita uma pesquisa no site [Quotes to Scrape](https://quotes.toscrape.com/) procurando todas as *quotes*, frases, relacionadas à *tag* informada e retorná-las no formato *json* para o usuário, além de persisti-las no banco de dados para futuras requisições.

- **GET** que utiliza a url http://localhost:3000/quotes. Pode ser acessada por um navegador ou aplicativo para analise de requisições HTTP, sendo retornadas todas as *quotes* disponíveis no banco de dados.


## Retornos

Retorno de uma requisição de autenticação:

~~~json
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiSnVuaW9yIn0.ajhaDGYwlJXfDfN1WeRXExRRiqQRlqFuid5imQWOwOK"
}
~~~



Caso a aplicação tenha sucesso em encontrar uma ou mais *quotes* relacioandas à *tag* pesquisada, ela retornará um json de acordo com a seguinte estrutura:

~~~json
{
  [
      {
        "quote": "frase",
        "author": "nome do autor",
        "author_about": "link para o perfil do autor",
        "tags": ["tag1", "tag2"]
      }
  ]
}
~~~

Em caso contrário retornará o json junto de um código de status 404:

~~~json
{
    "status": "404",
    "error": "tag not found"
}
~~~
