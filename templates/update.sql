--
-- PGVER update database script
--

SELECT pg_advisory_xact_lock_shared(0, 0);

\i {{pgver_work_dir}}/drop_functional.sql

{% for item in __pgver_updates %}

\i {{pgver_work_dir}}/updates/update--{{item}}.sql

SELECT pgver.bump_version({{item}});

{% endfor %}

{#% if database_deploy_testdata %#}

-- \i /mnt/ansible/testdata/testdata.sql

{#% endif %#}

\i {{pgver_work_dir}}/deploy_functional.sql
