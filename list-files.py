# Make HTTP requests
import requests

# Do work within JSON
import json


# Set our Auth URL
auth_url = 'https://identity.api.rackspacecloud.com/v2.0/tokens'


# Set our Openstack User Name
user_name = '<SOMEUSERID>'


# Set our Openstack API Key
api_key = '<SOMERAXAPIKEY>'


# Create some basic Headers
basic_headers = {'Content-Type': 'application/json'}


# Build the POST Data
post_data = {
    "auth": {
        "RAX-KSKEY:apiKeyCredentials": {
            "username": "%s" % user_name,
            "apiKey": "%s" % api_key
        }
    }
}


service_catalog = requests.post(
    auth_url,
    headers=basic_headers,
    data=json.dumps(post_data)
)


service_catalog_dict = json.loads(service_catalog.content)
access = service_catalog_dict['access']
all_service_catalog_endpoints = access['serviceCatalog']

for service in all_service_catalog_endpoints:
    if 'name' in service and service['name'] == 'cloudFiles':
        print service



# print json.dumps(service_catalog.json(), indent=2)
print service_catalog.status_code

