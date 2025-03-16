CREATE OR ALTER VIEW vw_f_game_stats_test AS
WITH GameUnpivot AS (
    SELECT 
        G.game_date,
        OS.game_id,
        OS.team_id_home,
        OS.team_id_away,
        OS.pts_paint_home,
        OS.pts_2nd_chance_home,
        OS.pts_fb_home,
        OS.largest_lead_home,
        OS.lead_changes,
        OS.times_tied,
        CAST(REPLACE(OS.team_turnovers_home, '.0', '') AS INT) AS team_turnovers_home,
        CAST(REPLACE(OS.team_rebounds_home, '.0', '') AS INT) AS team_rebounds_home,
        CAST(REPLACE(OS.pts_off_to_home, '.0', '') AS INT) AS pts_off_to_home,
        OS.pts_paint_away,
        OS.pts_2nd_chance_away,
        OS.pts_fb_away,
        OS.largest_lead_away,
        CAST(REPLACE(OS.team_turnovers_away, '.0', '') AS INT) AS team_turnovers_away,
        CAST(REPLACE(OS.team_rebounds_away, '.0', '') AS INT) AS team_rebounds_away,
        CAST(REPLACE(OS.pts_off_to_away, '.0', '') AS INT) AS pts_off_to_away
    FROM other_stats OS
    JOIN game G ON OS.game_id = G.game_id  -- Adicionado JOIN para filtrar pela data
    WHERE TRY_CONVERT(DATE, G.game_date) >= DATEADD(YEAR, -10, GETDATE())
)
SELECT
    game_date,
    game_id,
    team_id,
    pts_paint_home,
    pts_2nd_chance_home,
    pts_fb_home,
    largest_lead_home,
    lead_changes,
    times_tied,
    team_turnovers_home,
    team_rebounds_home,
    pts_off_to_home,
    pts_paint_away,
    pts_2nd_chance_away,
    pts_fb_away,
    largest_lead_away,
    team_turnovers_away,
    team_rebounds_away,
    pts_off_to_away
FROM GameUnpivot
UNPIVOT (
    team_id FOR team_role IN (team_id_home, team_id_away)
) AS unpvt;
