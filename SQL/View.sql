ALTER VIEW vw_player_tournament_master AS
SELECT 
    player_id,
    
    -- ==========================================
    -- 1. البيانات الأساسية للاعب
    -- ==========================================
    MAX(player_name) AS player_name,
    MAX(age) AS age,
    MAX(nationality) AS nationality,
    MAX(team) AS team,
    MAX(position) AS position,
    MAX(club_name) AS club_name,
    MAX(market_value_eur) AS market_value_eur,
    
    -- ==========================================
    -- 2. إحصائيات المشاركة (المباريات والدقائق)
    -- ==========================================
    COUNT(match_id) AS matches_played,
    SUM(minutes_played) AS total_minutes_played,
    
    -- ==========================================
    -- 3. الطبقة الأولى: الأداء الهجومي
    -- ==========================================
    SUM(goals) AS total_goals,
    SUM(assists) AS total_assists,
    SUM(expected_goals_xg) AS total_xg,
    SUM(expected_assists_xa) AS total_xa,
    SUM(shots) AS total_shots,
    SUM(shots_on_target) AS total_shots_on_target,
    CASE 
        WHEN SUM(shots) = 0 THEN 0 
        ELSE CAST(SUM(shots_on_target) * 100.0 / SUM(shots) AS DECIMAL(5,2)) 
    END AS shot_accuracy_percentage,
    SUM(key_passes) AS total_key_passes,

    -- ==========================================
    -- 4. الطبقة الثانية: الأداء الدفاعي والتكتيكي
    -- ==========================================
    SUM(tackles) AS total_tackles,
    SUM(interceptions) AS total_interceptions,
    SUM(clearances) AS total_clearances,
    (SUM(tackles) + SUM(interceptions) + SUM(clearances)) AS total_defensive_actions,
    SUM(successful_passes) AS total_successful_passes,
    SUM(total_passes) AS total_passes_attempted,
    CASE 
        WHEN SUM(total_passes) = 0 THEN 0 
        ELSE CAST(SUM(successful_passes) * 100.0 / SUM(total_passes) AS DECIMAL(5,2)) 
    END AS pass_accuracy_percentage,
    SUM(clean_sheet) AS total_clean_sheets,
    SUM(yellow_cards) AS total_yellow_cards,
    SUM(red_cards) AS total_red_cards,

    -- ==========================================
    -- 5. الطبقة الثالثة: المجهود البدني واللياقة
    -- ==========================================
    SUM(distance_covered_km) AS total_distance_covered_km,
    MAX(top_speed_kmh) AS max_top_speed_kmh,
    AVG(stamina_score) AS avg_stamina_score,

    -- ==========================================
    -- 6. الطبقة الرابعة: التأثير العام وتقييمات البطولة
    -- ==========================================
    AVG(player_rating) AS avg_player_rating,
    SUM(player_of_match_awards) AS total_motm_awards,
    AVG(performance_score) AS avg_performance_score,
    AVG(offensive_contribution) AS avg_offensive_contribution,
    AVG(defensive_contribution) AS avg_defensive_contribution,
    AVG(creativity_score) AS avg_creativity_score,
    AVG(consistency_score) AS avg_consistency_score

FROM player_match_performance
GROUP BY player_id;
GO
