## O Aplicativo

O aplicativo possui duas telas: uma listagem de jogos e o detalhe de cada jogo.

### Tela Inicial

- Lista de jogos
  - Nome dos times
  - Escudos
  - Placar
  - Data e horário

Considere as seguintes condições:

- A lista de jogos deve estar disponível offline

- O usuário pode querer atualizar a lista de jogos

- Clicar sobre um jogo leva o usuário para a tela de detalhe daquele jogo

Exemplo de uma lista de jogos na web (lado direito): [brasileirão série a](http://globoesporte.globo.com/futebol/brasileirao-serie-a/).

### Detalhe do Jogo

- Detalhe do jogo
  - Nome dos times
  - Escudos
  - Placar
  - Data e horário
  - Local

- Lance a Lance
  - Lista de momentos importantes do jogo
    - Tempo no jogo
    - Descrição

- Atalho para voltar para a tela inicial


## Descrição das soluções criadas
O app descrito acima foi criado nas arquiteturas MVVM, VIP(clean Swift) e VIPER


### API

Para Lista de Jogos foi utilizado a propria api do Globo Esporte:
```
https://api.globoesporte.globo.com/tabela/d1a37fa4-e948-43a6-ba53-ab24ab3a45b1/fase/fase-unica-seriea-2018/rodada/2/jogos/
```
Para a listagem de momentos importantes para o "Lance a Lance" foi feito um micro serviço em node que recebe a url encontrada na api de jogos na propriedade `transmissao.url` e "crawleia" os dados e retorna um Json para o app.
```
https://lalmartinez.herokuapp.com/?url=https://globoesporte.globo.com/sp/futebol/brasileirao-serie-a/jogo/16-09-2018/corinthians-sport.ghtml
```

### Bibliotecas Utilizadas

  - Alamofire: Para requsições HTTP 
    - https://github.com/Alamofire/Alamofire
  - Realm: Para armazenamento de dados locais
    - https://realm.io/
  - SDWebImage: Para download de imagens com um bom gerenciamento de cache
    - https://github.com/SDWebImage/SDWebImage

### Melhorias
  - Poderia ter feito um loading na tela de Listagem de partidas igual ao usado na tela de resumo
  - Gostaria de incluir uma animação de transição entre a mudaça de listagem de partida e a tela de resumo.
