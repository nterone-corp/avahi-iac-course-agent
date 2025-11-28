CREATE USER ai_agent_user WITH PASSWORD 'secure_random_password';
GRANT SELECT ON courses, categories,
platforms, subjects, exams, video_on_demands, videos, testimonials,
public_featured_events TO ai_agent_user;
CREATE VIEW ai_safe_users AS SELECT id,
first_name, last_name, email, company_id, origin_region, active_regions, created_at,
updated_at, archived, active FROM users;
CREATE VIEW ai_safe_courses AS SELECT id, slug, title, abbreviation, platform_id, price, origin_region,
active_regions, created_at, updated_at, option_for, developed_by_nterone, search_terms
FROM courses
CREATE VIEW ai_safe_events AS SELECT id, start_date, end_date, format, price, course_id,
guaranteed, active, start_time, end_time, city, state, status, public, language, time_zone,
archived, approved, max_student_count, origin_region, active_regions FROM events;
GRANT SELECT ON ai_safe_users, ai_safe_events, ai_safe_courses TO ai_agent_user;

ALTER USER ai_agent_user CONNECTION LIMIT 5;
ALTER USER ai_agent_user SET statement_timeout = '30s';
ALTER USER ai_agent_user SET lock_timeout = '10s';

CREATE POLICY ai_agent_regional_policy ON courses FOR SELECT TO ai_agent_user USING
(origin_region = current_setting('app.current_region')::int);

CREATE POLICY ai_agent_user_policy
ON users FOR SELECT TO ai_agent_user USING (active = true AND archived = false)

CREATE POLICY ai_agent_course_policy
ON courses FOR SELECT TO ai_agent_user USING (hidden_from_public = false AND archived = false);

CREATE POLICY ai_agent_event_policy
ON events FOR SELECT TO ai_agent_user USING (active = true AND public = true);
