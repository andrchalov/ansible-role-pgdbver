--
-- PGVER update database script
--

BEGIN;

\cd '{{pgver_work_dir}}'

SELECT pg_advisory_xact_lock(0, 0);

\i {{pgver_work_dir}}/drop_functional.sql

{% for item in __pgver_updates %}

\i {{pgver_work_dir}}/updates/update--{{item}}.sql

SELECT pgver.bump_version({{item}});

{% endfor %}

{#% if database_deploy_testdata %#}

-- \i /mnt/ansible/testdata/testdata.sql

{#% endif %#}

\i {{pgver_work_dir}}/vars.sql

\i {{pgver_work_dir}}/deploy_functional.sql

COMMIT;
