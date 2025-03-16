SELECT *
FROM other_stats

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


--CREATE VIEW vw_f_game_score AS
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


SELECT
      TI.game_id
    ,TI.season_id
    ,TI.team_id_away
    ,TI.team_id_home
    --,TI.abbreviation
   -- ,TI.full_name AS team_name
   -- ,TI.city
    ,TI.game_date
    -- home stats
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
FROM game TI
LEFT JOIN other_stats OS
    ON TI.team_id_home = OS.team_id_home
    OR TI.team_id_away = OS.team_id_away;

SELECT * INTO cached_f_game_stats FROM vw_f_game_stats;

SELECT *
FROM cached_f_game_stats

EXEC sp_help 'cached_f_game_stats';


CREATE TABLE dim_calendar (
     calendar_date DATE PRIMARY KEY
    ,year INT
    ,month INT
    ,month_name VARCHAR(20)
    ,quarter INT
    ,quarter_name VARCHAR(10)
    ,day_of_week INT
    ,day_name VARCHAR(20)
    ,week_of_year INT
    ,is_weekend BIT
);

INSERT INTO dim_calendar (calendar_date, year, month, month_name, quarter, quarter_name, day_of_week, day_name, week_of_year, is_weekend)
SELECT DISTINCT 
     game_date AS calendar_date
    ,YEAR(game_date) AS year
    ,MONTH(game_date) AS month
    ,DATENAME(MONTH, game_date) AS month_name
    ,DATEPART(QUARTER, game_date) AS quarter
    ,CASE DATEPART(QUARTER, game_date) 
        WHEN 1 THEN 'Q1' 
        WHEN 2 THEN 'Q2' 
        WHEN 3 THEN 'Q3' 
        WHEN 4 THEN 'Q4' 
    END AS quarter_name
    ,DATEPART(WEEKDAY, game_date) AS day_of_week
    ,DATENAME(WEEKDAY, game_date) AS day_name
    ,DATEPART(WEEK, game_date) AS week_of_year
    ,CASE 
        WHEN DATEPART(WEEKDAY, game_date) IN (1, 7) THEN 1 
        ELSE 0 
    END AS is_weekend
FROM vw_f_game_score
WHERE game_date IS NOT NULL;



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
    ,LS.pts_qtr1_home AS pts_qtr1_home
    ,LS.pts_qtr2_home AS pts_qtr2_home
    ,LS.pts_qtr3_home AS pts_qtr3_home
    ,LS.pts_qtr4_home AS pts_qtr4_home
    ,LS.pts_qtr1_away AS pts_qtr1_away
    ,LS.pts_qtr2_away AS pts_qtr2_away
    ,LS.pts_qtr3_away AS pts_qtr3_away
    ,LS.pts_qtr4_away AS pts_qtr4_away
    ,LS.pts_ot1_home AS pts_ot1_home
    ,LS.pts_ot2_home AS pts_ot2_home
    ,LS.pts_ot3_home AS pts_ot3_home
    ,LS.pts_ot4_home AS pts_ot4_home
    ,LS.pts_ot1_away AS pts_ot1_away
    ,LS.pts_ot2_away AS pts_ot2_away
    ,LS.pts_ot3_away AS pts_ot3_away
    ,LS.pts_ot4_away AS pts_ot4_away
FROM GameUnpivot GU
LEFT JOIN team_history T 
    ON GU.team_id = T.team_id
LEFT JOIN other_stats OS 
    ON GU.game_id = OS.game_id
LEFT JOIN line_score LS 
    ON GU.game_id = LS.game_id
WHERE GU.game_id = 10500067

SELECT 
    AVG(ast_home)
FROM vw_f_game_stats

SELECT
    OS.game_id
    ,OS.team_rebounds_away
    ,OS.team_rebounds_home
    ,G.ast_away
    ,G.ast_home
    ,G.reb_away
    ,G.reb_home
    ,G.tov_away
    ,G.tov_home
FROM game G
INNER JOIN other_stats OS ON G.game_id = OS.game_id

SELECT * 
FROM other_stats
SELECT *
FROM game
SELECT *
FROM team

SELECT OS.game_id, G.game_id, G.ast_home, G.ast_away 
FROM other_stats OS
LEFT JOIN game G ON OS.game_id = G.game_id
WHERE G.game_id IS NULL;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('game', 'other_stats') AND COLUMN_NAME = 'game_id';



SELECT TOP 10 OS.game_id, G.game_id, G.game_date
FROM other_stats OS
LEFT JOIN game G ON OS.game_id = G.game_id
WHERE TRY_CONVERT(DATE, G.game_date) >= DATEADD(YEAR, -10, GETDATE());