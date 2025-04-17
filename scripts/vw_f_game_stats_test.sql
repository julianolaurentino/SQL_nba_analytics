CREATE OR ALTER VIEW vw_f_game_stats_test AS
WITH GameUnpivot AS (
    SELECT 
        TRY_CONVERT(DATE, G.game_date) AS game_date,
        CAST(REPLACE(G.stl_away, '.0', '') AS INT) AS stl_away,
        CAST(REPLACE(G.stl_home, '.0', '' )AS INT) stl_home,
        OS.game_id,
        OS.team_id_home,
        OS.team_id_away,
        CAST(OS.pts_paint_home AS INT) AS pts_paint_home,
        CAST(OS.pts_2nd_chance_home AS INT) AS pts_2nd_chance_home,
        CAST(OS.pts_fb_home AS INT) AS pts_fb_home,
        CAST(OS.largest_lead_home AS INT) AS largest_lead_home,
        CAST(OS.lead_changes AS INT) AS lead_changes,
        CAST(OS.times_tied AS INT ) AS times_tied, 
        CAST(REPLACE(OS.team_turnovers_home, '.0', '') AS INT) AS team_turnovers_home,
        CAST(REPLACE(OS.team_rebounds_home, '.0', '') AS INT) AS team_rebounds_home,
        CAST(REPLACE(OS.pts_off_to_home, '.0', '') AS INT) AS pts_off_to_home,
        CAST(OS.pts_paint_away AS INT) AS pts_paint_away,
        CAST(OS.pts_2nd_chance_away AS INT) AS pts_2nd_chance_away,
        CAST(OS.pts_fb_away AS INT) AS pts_fb_away,
        CAST(OS.largest_lead_away AS INT) AS largest_lead_away,
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
    stl_away,
    stl_home,
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
