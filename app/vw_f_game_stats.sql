SELECT
    G.game_id
    ,G.team_id_home
    ,G.team_id_away
    ,G.season_id
    ,TRY_CONVERT(DATE, G.game_date , 111) AS game_date
FROM game G



SELECT *
FROM team_details