# update-shards.sh

Command line tool to update Couchdb's shards with node ip address

## Usage example:

./update-shards.sh --url=https://admin:password@127.0.0.1:5986 --ip=172.43.0.2

## Parameters

* --url: full url to the admin interface (chttp.. default port 5986)
* --ip: node ip address

## Known Issues and workarounds

[Shard remapping and underscores conflict](https://issues.apache.org/jira/browse/COUCHDB-3237) : can't update metadata from databases with names beginning with underscore
