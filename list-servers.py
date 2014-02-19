# Make HTTP requests
import requests

# Do work within JSON
import json


# Make our output Debug
# import httplib
# httplib.HTTPConnection.debuglevel = 1


# Set our Tenant ID
tenant_id = 'REPLACEME'


# Set our Token ID
token_id = 'REPLACEME'


region_id = 'REPLACEME'


# Set the servers URL that we want to use
servers_url = 'https://%s.servers.api.rackspacecloud.com/v2/%s/servers/detail' % (region_id, tenant_id)


# Load our Authentication Headers
auth_headers = {'X-Auth-Token': '%s' % token_id}


# Get a list of servers
get_servers_list = requests.get(
    servers_url, headers=auth_headers
)

print json.dumps(get_servers_list.json(), indent=2)
