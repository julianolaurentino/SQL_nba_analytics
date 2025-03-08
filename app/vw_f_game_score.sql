-- /*==================================================================================================================          
-- CRIAÇÃO: JULIANO
-- DATA: 2025-03-08
-- DESCRIÇÃO: TABELA FATO DE GAME SCORE
-- ==================================================================================================================*/
-- /*==================================================================================================================          
-- INDICE
-- ST = STRING (TEXTO)
-- NM = NUMBER (FLOAT, INT , ETC..)
-- DT = DATE
-- ID = NUMBER (CHAVE UNICA DE RELACIONAMENTO)
-- ==================================================================================================================*/
-- /*==================================================================================================================
ALTER VIEW vw_f_game_score AS(
SELECT 
    G.game_id
    ,G.season_id
    ,T.id AS team_id
    ,TRY_CONVERT(DATE, G.game_date) AS game_date
    ,G.pts_home
    ,G.pts_away
    ,G.wl_home
    ,G.wl_away
    ,LS.pts_qtr1_home
    ,LS.pts_qtr2_home
    ,LS.pts_qtr3_home
    ,LS.pts_qtr4_home
    ,LS.pts_qtr1_away
    ,LS.pts_qtr2_away
    ,LS.pts_qtr3_away
    ,LS.pts_qtr4_away
    ,LS.pts_ot1_home
    ,LS.pts_ot2_home
    ,LS.pts_ot3_home
    ,LS.pts_ot4_home
    ,LS.pts_ot1_away
    ,LS.pts_ot2_away
    ,LS.pts_ot3_away
    ,LS.pts_ot4_away
FROM game G
LEFT JOIN team T ON G.team_id_home = T.id OR G.team_id_away = T.id
LEFT JOIN other_stats OS ON G.game_id = OS.game_id
LEFT JOIN line_score LS ON G.game_id = LS.game_id
)