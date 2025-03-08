-- /*==================================================================================================================          
-- CRIAÇÃO: JULIANO
-- DATA: 2025-03-07
-- DESCRIÇÃO: TABELA DIMENSAO DE PLAYERS
-- ==================================================================================================================*/
-- /*==================================================================================================================          
-- INDICE
-- ST = STRING (TEXTO)
-- NM = NUMBER (FLOAT, INT , ETC..)
-- DT = DATE
-- ID = NUMBER (CHAVE UNICA DE RELACIONAMENTO)
-- ==================================================================================================================*/
-- /*==================================================================================================================
ALTER VIEW vw_dim_player AS(
SELECT
    DH.team_id
    ,CONCAT(DH.team_city, ' ',DH.team_name) team_name
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
FROM common_player_info CPI
LEFT JOIN draft_combine_stats DCS ON CPI.person_id = DCS.player_id
LEFT JOIN draft_history DH ON CPI.person_id = DH.person_id
LEFT JOIN player P ON CPI.person_id = P.id
)