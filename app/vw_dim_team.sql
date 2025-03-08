-- /*==================================================================================================================          
-- CRIAÇÃO: JULIANO
-- DATA: 2025-03-07
-- DESCRIÇÃO: TABELA DIMENSAO DE TEAM
-- ==================================================================================================================*/
-- /*==================================================================================================================          
-- INDICE
-- ST = STRING (TEXTO)
-- NM = NUMBER (FLOAT, INT , ETC..)
-- DT = DATE
-- ID = NUMBER (CHAVE UNICA DE RELACIONAMENTO)
-- ==================================================================================================================*/
-- /*==================================================================================================================
ALTER VIEW vw_dim_team AS (
SELECT 
    T.id AS team_id
    ,T.nickname
    ,T.abbreviation
    ,T.full_name
    ,T.city
    ,T.[state]
    ,SUBSTRING(T.year_founded, 1, CHARINDEX('.', T.year_founded) -1) AS year_founded
    --,SUBSTRING(CPI.jersey, 1, CHARINDEX('.', CPI.jersey) -1) AS jersey_number
    ,TD.arena
    ,TD.arenacapacity
    ,CASE
        WHEN T.full_name IN ('Cleveland Cavaliers'
                            ,'Boston Celtics'
                            ,'New York Knicks'    
                            ,'Milwaukee Bucks'
                            ,'Indiana Pacers'
                            ,'Detroit Pistons'
                            ,'Miami Heat'
                            ,'Orlando Magic'
                            ,'Atlanta Hawks'
                            ,'Chicago Bulls'
                            ,'Brooklyn Nets'
                            ,'Philadelphia 76ers'
                            ,'Toronto Raptors'
                            ,'Charlotte Hornets'
                            ,'Washington Wizards'
                            ) THEN 'east'
        ELSE 'west'
    END AS conference
    ,CASE 
        WHEN T.full_name IN ('Boston Celtics'
                            ,'Philadelphia 76ers'
                            ,'New York Knicks'
                            ,'Brooklyn Nets'
                            ,'Toronto Raptors'
                            ) THEN 'Atlantic'
        WHEN T.full_name IN ('Milwaukee Bucks'
                            ,'Cleveland Cavaliers'
                            ,'Chicago Bulls'
                            ,'Indiana Pacers'
                            ,'Detroit Pistons'
                            ) THEN 'Center'
        WHEN T.full_name IN ('Miami Heat'
                            ,'Atlanta Hawks'
                            ,'Washington Wizards'
                            ,'Orlando Magic'
                            ,'Charlotte Hornets'
                            ) THEN 'South-east'
        WHEN T.full_name IN ('Denver Nuggets'
                            ,'Minnesota Timberwolves'
                            ,'Oklahoma City Thunder'
                            ,'Utah Jazz'
                            ,'Portland Trail Blazers'
                            ) THEN 'North-east'
        WHEN T.full_name IN ('Sacramento Kings'
                            ,'Phoenix Suns'
                            ,'Los Angeles Clippers'
                            ,'Golden State Warriors'
                            ,'Los Angeles Lakers'
                            ) THEN 'Pacific'
        ELSE 'South-west'
    END AS division
FROM team T
LEFT JOIN team_details TD
    ON T.id = TD.team_id
)

--sp_help 'vw_dim_team'