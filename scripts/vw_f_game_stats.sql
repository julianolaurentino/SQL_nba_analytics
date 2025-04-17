-- /*==================================================================================================================
-- CRIAÇÃO: JULIANO
-- DATA: 2025-03-08
-- DESCRIÇÃO: TABELA FATO DE GAME STATS
-- ==================================================================================================================*/
-- /*==================================================================================================================
-- INDICE
-- ST = STRING (TEXTO)
-- NM = NUMBER (FLOAT, INT , ETC..)
-- DT = DATE
-- ID = NUMBER (CHAVE UNICA DE RELACIONAMENTO)
-- ==================================================================================================================*/
-- /*==================================================================================================================
CREATE OR ALTER VIEW vw_f_game_stats AS
WITH GameUnpivot AS (
    SELECT 
         game_id
        ,season_id
        ,TRY_CONVERT(DATE, game_date) AS game_date
        ,team_id
    FROM 
        (SELECT 
             G.game_id
            ,G.season_id
            ,G.game_date
            ,G.team_id_home
            ,G.team_id_away
        FROM game G
        WHERE TRY_CONVERT(DATE, G.game_date) >= DATEADD(YEAR, -10, GETDATE())
        ) AS src
    UNPIVOT (
        team_id FOR team_role IN (team_id_home, team_id_away)
    ) AS unpvt
),
TeamInfo AS (
    SELECT 
         GU.game_id
        ,GU.season_id
        ,GU.team_id
        ,GU.game_date
        ,T.abbreviation
        ,T.team_name
        ,T.city
    FROM GameUnpivot GU
    LEFT JOIN vw_dim_team T 
        ON GU.team_id = T.team_id
),
OtherStats AS (
    SELECT 
         OS.game_id
        ,OS.team_id_home
        ,OS.team_id_away
        ,OS.pts_paint_home
        ,OS.pts_2nd_chance_home
        ,OS.pts_fb_home
        ,OS.largest_lead_home
        ,OS.lead_changes
        ,OS.times_tied
        ,OS.team_turnovers_home
        ,OS.team_rebounds_home
        ,OS.pts_off_to_home
        ,OS.pts_paint_away
        ,OS.pts_2nd_chance_away
        ,OS.pts_fb_away
        ,OS.largest_lead_away
        ,OS.team_turnovers_away
        ,OS.team_rebounds_away
        ,OS.pts_off_to_away
    FROM other_stats OS
)
SELECT
      TI.game_id
    ,TI.season_id
    ,TI.team_id
    ,TI.abbreviation
    ,TI.team_name
    ,TI.city
    ,TI.game_date
    -- home stats
    ,CASE WHEN TI.team_id = OS.team_id_home THEN TRY_CONVERT(INT, OS.pts_paint_home) END AS pts_paint_home
    ,CASE WHEN TI.team_id = OS.team_id_home THEN TRY_CONVERT(INT, OS.pts_2nd_chance_home) END AS pts_2nd_chance_home
    ,CASE WHEN TI.team_id = OS.team_id_home THEN TRY_CONVERT(INT, OS.pts_fb_home) END AS pts_fb_home
    ,CASE WHEN TI.team_id = OS.team_id_home THEN TRY_CONVERT(INT, OS.largest_lead_home) END AS largest_lead_home
    ,CASE WHEN TI.team_id = OS.team_id_home THEN TRY_CONVERT(INT, OS.team_turnovers_home) END AS team_turnovers_home
    ,CASE WHEN TI.team_id = OS.team_id_home THEN TRY_CONVERT(INT, OS.team_rebounds_home) END AS team_rebounds_home
    ,CASE WHEN TI.team_id = OS.team_id_home THEN TRY_CONVERT(INT, OS.pts_off_to_home) END AS pts_off_to_home
    -- away stats
    ,CASE WHEN TI.team_id = OS.team_id_away THEN TRY_CONVERT(INT, OS.pts_paint_away) END AS pts_paint_away
    ,CASE WHEN TI.team_id = OS.team_id_away THEN TRY_CONVERT(INT, OS.pts_2nd_chance_away) END AS pts_2nd_chance_away
    ,CASE WHEN TI.team_id = OS.team_id_away THEN TRY_CONVERT(INT, OS.pts_fb_away) END AS pts_fb_away
    ,CASE WHEN TI.team_id = OS.team_id_away THEN TRY_CONVERT(INT, OS.largest_lead_away) END AS largest_lead_away
    ,CASE WHEN TI.team_id = OS.team_id_away THEN TRY_CONVERT(INT, OS.team_turnovers_away) END AS team_turnovers_away
    ,CASE WHEN TI.team_id = OS.team_id_away THEN TRY_CONVERT(INT, OS.team_rebounds_away) END AS team_rebounds_away
    ,CASE WHEN TI.team_id = OS.team_id_away THEN TRY_CONVERT(INT, OS.pts_off_to_away) END AS pts_off_to_away
    ,OS.lead_changes
    ,OS.times_tied
FROM TeamInfo TI
LEFT JOIN OtherStats OS
    ON TI.game_id = OS.game_id