#!/bin/bash
#
# update couchdb's shard's metadata to use a new ip address (backup from couchdb 2.0 files)
#

function usage() {
  echo "Usage: $0 --url=<url> --ip=<new ip address>"
  echo -e "\t-u|--url\tCouchDB admin url ('http(s)://admin:password@127.0.0.1:5986')"
  echo -e "\t-i|--ip\tCouchDB's node ip address"
  exit 1
}

# not all four arguments:
if [[ -z "$2" ]]; then
  usage
fi

for i in "$@"; do
  case $i in
    -u=* | --url=*)
      fullurl="${i#*=}"
      shift # past argument=value
      ;;
    -i=* | --ip=*)
      ip="${i#*=}"
      shift # past argument=value
      ;;
    *) ;; # unknown option
  esac
done

# extract the protocol
proto="$(echo $fullurl | grep :// | sed -e's,^\(.*://\).*,\1,g' -e 's|://||')"
if [[ -z "${proto}" ]]; then
  proto="http"
fi

# remove the protocol
url="$(echo ${fullurl/$proto:\/\//})"

# extract the user (if any)
auth="$(echo $url | grep @ | cut -d@ -f1)"
if [[ -z "${auth}" ]]; then
  echo "Error: no authentication"
  usage
fi

user="$(echo $auth | cut -d: -f1)"
if [[ -z "${user}" ]]; then
  echo "Error: no username"
  usage
fi
pass="$(echo $auth | cut -d: -f2)"
if [[ -z "${pass}" ]]; then
  echo "Error: no password"
  usage
fi

# extract the host
host="$(echo ${url/$auth@/} | cut -d/ -f1 | cut -d: -f1)"
if [[ -z "${host}" ]]; then
  host="localhost"
fi

# by request - try to extract the port
port="$(echo ${url/$auth@/} | cut -d/ -f1 | grep ':' | cut -d: -f2)"
if [[ -z "${port}" ]]; then
  port=5986
fi

echo "  proto: $proto"
echo "  user: $user"
echo "  pass: $pass"
echo "  host: $host"
echo "  port: $port"
echo ""
echo "  new ip address: $ip"
echo ""

export ip="${ip}"
echo "Running:"
echo "  cdbdump -k -r ${proto} -u ${user} -p ${pass} -h ${host} -P ${port} -d _dbs | cdbmorph -f ./morph.js | cdbload -r ${proto} -u ${user} -p ${pass} -h ${host} -P ${port} -v -d _dbs"
cdbdump -k -r ${proto} -u ${user} -p ${pass} -h ${host} -P ${port} -d _dbs | cdbmorph -f ./morph.js | cdbload -r ${proto} -u ${user} -p ${pass} -h ${host} -P ${port} -v -d _dbs
