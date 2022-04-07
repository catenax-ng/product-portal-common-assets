psql "host=catenaxdev003database.postgres.database.azure.com port=5432 dbname=postgres user=CatenaX@catenaxdev003database password=$CX_POSTGRES_PASSWORD sslmode=require"

select app_id,name,thumbnail_url from portal.apps;
update portal.apps set thumbnail_url='https://catenaxdev003util.blob.core.windows.net/assets/apps/images/SomeIcon.png' where app_id='APP_ID';
