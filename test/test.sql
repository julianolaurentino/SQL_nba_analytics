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


SELECT * 
FROM other_stats

SELECT * 
FROM line_score

SELECT *
FROM game_info

