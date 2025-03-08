
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
CREATE VIEW vw_game_stats AS
SELECT TOP 100
      TI.game_id
    ,TI.season_id
    ,TI.team_id
    ,TI.abbreviation
    ,TI.full_name AS team_name
    ,TI.city

    -- home stas
    ,OS.pts_paint_home
    ,OS.pts_2nd_chance_home
    ,OS.pts_fb_home
    ,OS.largest_lead_home
    ,OS.lead_changes
    ,OS.times_tied
    ,OS.team_turnovers_home
    ,OS.total_turnovers_home
    ,OS.team_rebounds_home
    ,OS.pts_off_to_home

    -- away stats
    ,OS.team_id_away
    ,OS.pts_paint_away
    ,OS.pts_2nd_chance_away
    ,OS.pts_fb_away
    ,OS.largest_lead_away
    ,OS.team_turnovers_away
    ,OS.total_turnovers_away
    ,OS.team_rebounds_away
    ,OS.pts_off_to_away
FROM 
    (
    SELECT 
         G.game_id
        ,G.season_id
        ,TRY_CONVERT(DATE, G.game_date) AS game_date
        ,T.id AS team_id
        ,T.abbreviation
        ,T.full_name
        ,T.city
    FROM game G
    LEFT JOIN team T 
        ON G.team_id_home = T.id 
        OR G.team_id_away = T.id
    ) TI
LEFT JOIN 
    (
        SELECT 
         OS.team_id_home
        ,OS.team_id_away
        ,OS.pts_paint_home
        ,OS.pts_2nd_chance_home
        ,OS.pts_fb_home
        ,OS.largest_lead_home
        ,OS.lead_changes
        ,OS.times_tied
        ,OS.team_turnovers_home
        ,OS.total_turnovers_home
        ,OS.team_rebounds_home
        ,OS.pts_off_to_home
        ,OS.pts_paint_away
        ,OS.pts_2nd_chance_away
        ,OS.pts_fb_away
        ,OS.largest_lead_away
        ,OS.team_turnovers_away
        ,OS.total_turnovers_away
        ,OS.team_rebounds_away
        ,OS.pts_off_to_away
        FROM other_stats OS
    ) OS 
    ON TI.team_id = OS.team_id_home 
    OR TI.team_id = OS.team_id_away;