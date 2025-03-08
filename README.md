# SQL_nba_analytics

# **Projeto de Análise de Jogos da NBA 🏀**

Este projeto visa a modelagem e análise de dados de jogos de basquete. Utilizando dados extraídos de diversas fontes, o objetivo é realizar consultas eficientes e visualizações detalhadas sobre o desempenho de jogadores e times ao longo de diferentes temporadas. A modelagem de dados foi realizada em um banco de dados SQL Server, com o uso de tabelas de dimensão (DIM) e tabelas de fatos (FACT), e a visualização dos dados é feita no Power BI.

## **Estrutura do Banco de Dados**

O banco de dados é composto por várias views e tabelas que organizam os dados de forma a permitir consultas rápidas e precisas sobre jogos, equipes, jogadores, temporadas e estatísticas. As views e tabelas foram divididas em **tabelas de dimensão** e **tabelas de fato** para garantir uma modelagem eficiente e otimizada.

### **Tabelas de Dimensão**

As tabelas de dimensão contêm informações descritivas sobre os elementos do jogo, como equipes, jogadores e temporadas.

#### **vw_dim_season**
Contém informações sobre as temporadas:
- `game_id`: Identificador do jogo
- `season_id`: Identificador da temporada
- `season_type`: Tipo de temporada (Ex: Regular, Playoffs)
- `season_date`: Data da temporada

#### **vw_dim_player**
Contém informações sobre os jogadores:
- `team_id`: Identificador do time
- `team_name`: Nome do time
- `person_id`: Identificador do jogador
- `first_name`: Nome do jogador
- `last_name`: Sobrenome do jogador
- `player_name`: Nome completo do jogador
- `birth_date`: Data de nascimento do jogador
- `nationality`: Nacionalidade do jogador
- `jersey_number`: Número da camisa do jogador
- `jersey`: Descrição da camisa do jogador
- `univercity`: Universidade do jogador
- `position`: Posição do jogador
- `draft_year`: Ano do draft
- `weight`: Peso do jogador
- `height`: Altura do jogador
- `active_status`: Status ativo do jogador (Ativo/Inativo)

#### **vw_dim_team**
Contém informações sobre os times:
- `team_id`: Identificador do time
- `nickname`: Apelido do time
- `abbreviation`: Abreviação do time
- `team_name`: Nome do time
- `city`: Cidade do time
- `state`: Estado do time
- `year_founded`: Ano de fundação do time
- `arena`: Arena onde o time joga
- `arenacapacity`: Capacidade da arena
- `conference`: Conferência do time
- `division`: Divisão do time

#### **vw_dim_game**
Contém informações sobre os jogos:
- `game_id`: Identificador do jogo
- `season_id`: Identificador da temporada
- `team_id`: Identificador do time
- `game_date`: Data do jogo
- `team_name_home`: Nome do time da casa
- `team_name_away`: Nome do time visitante

### **Tabelas de Fato**

As tabelas de fato contêm as métricas e informações quantitativas sobre os jogos, como pontuação, estatísticas de desempenho e mais.

#### **vw_f_game_score**
Contém as pontuações e dados dos jogos:
- `game_id`: Identificador do jogo
- `season_id`: Identificador da temporada
- `team_id`: Identificador do time
- `game_date`: Data do jogo
- `pts_home`: Pontos do time da casa
- `pts_away`: Pontos do time visitante
- `wl_home`: Vitória/derrota do time da casa
- `wl_away`: Vitória/derrota do time visitante
- `pts_qtr1_home`: Pontos no 1º quarto (time da casa)
- `pts_qtr1_away`: Pontos no 1º quarto (time visitante)
- **Outras métricas de pontos por quarto e prorrogação para ambos os times**

#### **vw_f_game_stats**
Contém estatísticas detalhadas dos jogos:
- `game_id`: Identificador do jogo
- `season_id`: Identificador da temporada
- `team_id`: Identificador do time
- `abbreviation`: Abreviação do time
- `team_name`: Nome do time
- `game_date`: Data do jogo
- **Diversas estatísticas** como pontos na pintura, pontos de segunda chance, turnovers, rebotes, etc.

## **Tecnologias Utilizadas**

- **SQL Server**: Utilizado para criação das tabelas e views.
- **Power BI**: Para criação das visualizações e dashboards com base nas views geradas no SQL Server.

## **Como Rodar o Projeto**

1. **Importar os dados**: Importe os arquivos CSV para o SQL Server.
2. **Criar as views e tabelas**: Execute os scripts SQL para criar as views e tabelas no banco de dados.
3. **Consultas e análises**: Utilize as views para realizar consultas no banco de dados e obter informações sobre jogos, jogadores e times.
4. **Visualizações no Power BI**: Conecte-se ao banco de dados no Power BI e utilize as views como fontes de dados para criar gráficos e dashboards interativos.

## **Consultas Exemplos**

### **Pontuação dos Jogos de uma Temporada**
```sql
SELECT 
    G.game_id, 
    G.game_date, 
    T.team_name AS team_home, 
    G.pts_home, 
    T2.team_name AS team_away, 
    G.pts_away
FROM 
    vw_f_game_score G
JOIN 
    vw_dim_team T ON G.team_id_home = T.team_id
JOIN 
    vw_dim_team T2 ON G.team_id_away = T2.team_id
WHERE 
    G.season_id = '2024';
```

### **Estatísticas do Time Durante um Jogo**
```sql
SELECT 
    G.game_id, 
    T.team_name AS team_home, 
    GS.pts_paint_home, 
    GS.team_turnovers_home, 
    GS.team_rebounds_home
FROM 
    vw_f_game_stats GS
JOIN 
    vw_dim_team T ON GS.team_id = T.team_id
JOIN 
    vw_f_game_score G ON GS.game_id = G.game_id
WHERE 
    T.team_name = 'Los Angeles Lakers'
    AND G.game_date BETWEEN '2024-01-01' AND '2024-12-31';
```

## **Melhorias Futuras**
- **Adicionar mais estatísticas detalhadas** como aproveitamento de arremessos, assistências, entre outros.
- **Automatizar a ingestão de dados** utilizando ferramentas ETL.
- **Criar dashboards no Power BI** para visualização das tendências e padrões no desempenho dos times e jogadores ao longo das temporadas.

## Autor

- [@JulianoLaurentino](https://www.linkedin.com/in/julianolaurentinodasilva/)