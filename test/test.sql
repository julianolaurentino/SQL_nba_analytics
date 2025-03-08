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


SELECT TOP 100
    DH.team_id
    ,CPI.person_id
    ,CPI.first_name
    ,CPI.last_name
    ,CONCAT(CPI.first_name, ' ',CPI.last_name) AS player_name
    ,TRY_CONVERT(DATE, CPI.school) AS birth_date
    ,CPI.last_affiliation AS nationality
    ,SUBSTRING(CPI.jersey, 1, CHARINDEX('.', CPI.jersey) -1) AS jersey_number
    ,CPI.jersey
    ,DH.organization AS univercity
    ,DCS.position
    ,DCS.season AS draft_year
    ,DCS.weight
    ,DCS.height_w_shoes AS heith
    ,CASE 
        WHEN P.is_active = 1 THEN 'Active' 
        ELSE 'Inactive' 
    END AS active_status
        ,TRY_CONVERT(DATE, G.game_date) AS game_date
    ,G.pts_home
    ,G.pts_away
FROM common_player_info CPI
LEFT JOIN draft_combine_stats DCS ON CPI.person_id = DCS.player_id
LEFT JOIN draft_history DH ON CPI.person_id = DH.person_id
LEFT JOIN player P ON CPI.person_id = P.id
LEFT JOIN game G ON DH.team_id = G.team_id_away OR DH.team_id = G.team_id_home
