select *
from {{ source('ingest_db', 'vehicleyear') }}