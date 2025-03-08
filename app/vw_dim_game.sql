-- /*==================================================================================================================          
-- CRIAÇÃO: JULIANO
-- DATA: 2025-03-07
-- DESCRIÇÃO: TABELA DIMENSAO DE GAME
-- ==================================================================================================================*/
-- /*==================================================================================================================          
-- INDICE
-- ST = STRING (TEXTO)
-- NM = NUMBER (FLOAT, INT , ETC..)
-- DT = DATE
-- ID = NUMBER (CHAVE UNICA DE RELACIONAMENTO)
-- ==================================================================================================================*/
-- /*==================================================================================================================
CREATE VIEW vw_dim_game AS
SELECT DISTINCT
    G.game_id
    ,G.season_id
    ,DH.team_id AS team_id
    ,G.team_name_home
    ,G.team_name_away
    ,TRY_CONVERT(DATE, G.game_date) AS game_date
    ,G.pts_home
    ,G.pts_away
    ,G.wl_home
    ,G.wl_away
FROM game G
--LEFT JOIN team T ON G.team_id_home = T.id OR G.team_id_away = T.id
LEFT JOIN draft_history DH ON G.team_id_home = DH.team_id OR G.team_id_away = DH.team_id