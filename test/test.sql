SELECT *
FROM game

SELECT DISTINCT TOP 100 *
FROM game_summary
WHERE game_status_text = 'Final'


SELECT
    G.game_id
    ,G.season_id
    ,G.season_type
    ,GS.season AS seasson_date
FROM game G
LEFT JOIN game_info GI
    ON G.game_id = GI.game_id
LEFT JOIN game_summary GS
    ON G.game_id = GS.game_id
LEFT JOIN line_score ls
    ON G.game_id = LS.game_id
-- WHERE game_status_text <> 'Final'
-- ORDER BY seasson_date DESC



WITH GameUnpivot AS (
    SELECT 
        game_id
        ,season_id
        ,team_id  -- Agora temos uma única coluna para o time
        ,TRY_CONVERT(DATE, G.game_date) AS game_date
        ,pts_home
        ,pts_away
        ,wl_home
        ,wl_away
    FROM game G
    UNPIVOT (
        team_id FOR team_role IN (team_id_home, team_id_away)
    ) AS unpvt
)
SELECT 
     GU.game_id
    ,GU.season_id
    ,GU.team_id
    ,GU.game_date
    ,GU.pts_home
    ,GU.pts_away
    ,GU.wl_home
    ,GU.wl_away
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
FROM GameUnpivot GU
LEFT JOIN team_history T ON GU.team_id = T.team_id
LEFT JOIN line_score LS ON GU.game_id = LS.game_id;


CREATE VIEW vw_f_game_score AS
WITH GameUnpivot AS (
    SELECT 
         game_id
        ,season_id
        ,TRY_CONVERT(DATE, game_date) AS game_date
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
    ,GU.game_date
    ,GU.pts_home
    ,GU.pts_away
    ,GU.wl_home
    ,GU.wl_away
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
FROM GameUnpivot GU
LEFT JOIN team_history T 
    ON GU.team_id = T.team_id
LEFT JOIN other_stats OS 
    ON GU.game_id = OS.game_id
LEFT JOIN line_score LS 
    ON GU.game_id = LS.game_id;
