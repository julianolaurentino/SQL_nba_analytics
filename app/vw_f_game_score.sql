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
CREATE OR ALTER VIEW vw_f_game_score AS
WITH GameUnpivot AS (
    SELECT
         game_id
        ,season_id
        ,TRY_CONVERT(DATE, game_date) AS game_date
        ,team_name_home
        ,team_name_away
        ,team_id
        ,pts_home
        ,pts_away
        ,wl_home
        ,wl_away
    FROM 
        (SELECT 
             G.game_id
            ,G.season_id
            ,G.game_date
            ,G.team_name_home
            ,G.team_name_away
            ,G.pts_home
            ,G.pts_away
            ,G.wl_home
            ,G.wl_away
            ,G.team_id_home
            ,G.team_id_away
        FROM game G) AS src
    UNPIVOT (
        team_id FOR team_role IN (team_id_home, team_id_away)
    ) AS unpvt
)
SELECT 
     GU.game_id
    ,GU.season_id
    ,GU.team_id
    ,GU.team_name_home
    ,GU.team_name_away
    ,GU.game_date
    ,CAST(REPLACE(GU.pts_home, '.0', '') AS INT) AS pts_home
    ,CAST(REPLACE(GU.pts_away, '.0', '') AS INT) AS pts_away
    ,GU.wl_home
    ,GU.wl_away
    ,LS.pts_qtr1_home
    ,LS.pts_qtr2_home
    ,LS.pts_qtr3_home
    ,LS.pts_qtr4_home
    ,CAST(REPLACE(LS.pts_qtr1_away, '.0', '') AS INT) AS pts_qtr1_away
    ,LS.pts_qtr2_away
    ,LS.pts_qtr3_away
    ,CAST(REPLACE(LS.pts_qtr4_away, '.0', '') AS INT) AS pts_qtr4_away
    ,LS.pts_ot2_home
    ,LS.pts_ot3_home
    ,LS.pts_ot4_home
    ,LS.pts_ot1_away
    ,LS.pts_ot2_away
    ,LS.pts_ot3_away
    ,LS.pts_ot4_away
FROM GameUnpivot GU
LEFT JOIN team_history T 
    ON GU.team_id = T.team_id
LEFT JOIN other_stats OS 
    ON GU.game_id = OS.game_id
LEFT JOIN line_score LS 
    ON GU.game_id = LS.game_id