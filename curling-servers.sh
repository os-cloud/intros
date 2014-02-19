# Hello,
# as you begin to leverage the Rackspace API powered by Openstack here is how
# you would do everything with curl. This is a simple tutorial which will
# get you through the process of building a single server.


# As you work through these commands you will notice that I have some names that
# you have to replace. As I begin creating the commands I will notate all of
# the commands with what they are doing and if something is needed.



# Here is where you begin.



# "YOUR-USER-NAME" should be replaced with the username for your cloud account.
# "YOUR-API-KEY" should be replaced with the API key for your cloud account.


# Authentication:
curl https://identity.api.rackspacecloud.com/v2.0/tokens -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d '{"auth": {"RAX-KSKEY:apiKeyCredentials": {"username": "YOUR-USER-NAME", "apiKey": "YOUR-API-KEY", "tenantName": "YOUR-USER-NAME"}}}' | python -m json.tool


# After you run the previous command you will have a lot of output, this is the
# service catalog. Study the catalog, this is the key to consuming the API.


# From the Service Catalog you will need to get the following data from the
# catalog to continue.

# YOUR-TOKEN-ID should be replace with the tokenID from the service catalog
# YOUR-TENANT-ID should be replaced with the tenantID from the service catalog

# NOTE, Both the token ID and the Tenant is in the section named "token"
# Here is what that looks like should look like this
#         "token": {
#             "RAX-AUTH:authenticatedBy": [
#                 "APIKEY"
#             ],
#             "expires": "2014-02-20T11:47:06.438Z",
#             "id": "YOUR-TOKEN-ID",
#             "tenant": {
#                 "id": "YOUR-TENANT-ID",
#                 "name": "YOUR-TENANT-ID"
#             }
#         },


# Now that you have your Tenant ID and your Token ID, you need to look through
# the catalog and find the end point information for the datacenter you want to
# build a server.

# NOTE, this is what your Cloud Servers Endpoints look like
#         {
#             "endpoints": [
#                 {
#                     "publicURL": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID",
#                     "region": "YOUR-DATA-CENTER",
#                     "tenantId": "YOUR-TENANT-ID",
#                     "versionId": "2",
#                     "versionInfo": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2",
#                     "versionList": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/"
#                 }
#             ],
#             "name": "cloudServersOpenStack",
#             "type": "compute"
#         },

# in these commands you should replace YOUR-DATA-CENTER with the name of the
# data center you want to work with.



# In order to build a server you have to first settle on a flavor size.

# List Flavors
curl https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/flavors/detail -X GET -H "X-Auth-Project-Id: YOUR-USER-NAME"  -H "Accept: application/json" -H "X-Auth-Token: YOUR-TOKEN-ID" | python -m json.tool

# From the flavor list, find the flavor "id" you want to work with.
# NOTE, here is an example of a flavor entry
#         {
#             "OS-FLV-EXT-DATA:ephemeral": 0,
#             "OS-FLV-WITH-EXT-SPECS:extra_specs": {
#                 "class": "standard1",
#                 "disk_io_index": "2",
#                 "number_of_data_disks": "0"
#             },
#             "disk": 20,
#             "id": "2",
#             "links": [
#                 {
#                     "href": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/flavors/2",
#                     "rel": "self"
#                 },
#                 {
#                     "href": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/flavors/2",
#                     "rel": "bookmark"
#                 }
#             ],
#             "name": "512MB Standard Instance",
#             "ram": 512,
#             "rxtx_factor": 80.0,
#             "swap": 512,
#             "vcpus": 1
#         },



# List Images
curl https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/images/detail -X GET -H "X-Auth-Project-Id: YOUR-USER-NAME"  -H "Accept: application/json" -H "X-Auth-Token: YOUR-TOKEN-ID" | python -m json.tool

# From the image list you will find the image "id" that you want to work with
#         {
#             "OS-DCF:diskConfig": "AUTO",
#             "OS-EXT-IMG-SIZE:size": 542376911,
#             "created": "2014-01-23T17:56:12Z",
#             "id": "YOUR-IMAGE-ID",
#             "links": [
#                 {
#                     "href": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/images/YOUR-IMAGE-ID",
#                     "rel": "self"
#                 },
#                 {
#                     "href": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/YOUR-IMAGE-ID",
#                     "rel": "bookmark"
#                 },
#                 {
#                     "href": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/YOUR-IMAGE-ID",
#                     "rel": "alternate",
#                     "type": "application/vnd.openstack.image"
#                 }
#             ],
#             "metadata": {
#             },
#             "minDisk": 0,
#             "minRam": YOUR-IMAGE-RAM-SIZE,
#             "name": "YOUR-IMAGE-NAME",
#             "progress": 100,
#             "status": "ACTIVE",
#             "updated": "2014-01-29T21:08:44Z"
#         },



# Now that you have the following information:
# YOUR-IMAGE-ID
# YOUR-FLAVOR-ID
# YOUR-AUTH-TOKEN

# It is time to build a server. In this command you need to name your
# server and POST the JSON content to the API. This will inform
# NOVA compute to build you a sever with the information your have provided.

# YOUR-SERVER-NAME is the name of the server.

# Build Servers
curl https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/servers -X POST -H "X-Auth-Project-Id: YOUR-USER-NAME" -d '{"server": {"name": "YOUR-SERVER-NAME", "imageRef": "YOUR-IMAGE-ID", "flavorRef": "YOUR-FLAVOR-ID", "max_count": 1, "min_count": 1, "networks": [{"uuid": "00000000-0000-0000-0000-000000000000"}, {"uuid": "11111111-1111-1111-1111-111111111111"}]}}' -H "Content-Type: application/json" -H "Accept: application/json" -H "X-Auth-Token: YOUR-TOKEN-ID" | python -m json.tool


# NOTE, here is what you get back from the API when you POST a build command
#   {
#       "server": {
#           "OS-DCF:diskConfig": "AUTO",
#           "adminPass": "SomeRandomPassword",
#           "id": "YOUR-SERVER-ID",
#           "links": [
#               {
#                   "href": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/servers/YOUR-SERVER-ID",
#                   "rel": "self"
#               },
#               {
#                   "href": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/servers/YOUR-SERVER-ID",
#                   "rel": "bookmark"
#               }
#           ]
#       }
#   }


# Now that you built a server, lets list out all of your servers and see the status of our new server.
# List Servers:
curl https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/servers/detail -X GET -H "X-Auth-Project-Id: YOUR-USER-NAME" -H "Accept: application/json" -H "X-Auth-Token: YOUR-TOKEN-ID" | python -m json.tool



# When listing all of your server, you may have a lot of data to look at,
# So lets list only information on our one new server that we built.
# Here you will need the server YOUR-SERVER-ID in order to list inforamtion
# on the one server.

curl https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/servers/YOUR-SERVER-ID -X GET -H "X-Auth-Project-Id: YOUR-USER-NAME" -H "Accept: application/json" -H "X-Auth-Token: YOUR-TOKEN-ID" | python -m json.tool

#   {
#       "server": {
#           "OS-DCF:diskConfig": "MANUAL",
#           "OS-EXT-STS:power_state": 1,
#           "OS-EXT-STS:task_state": null,
#           "OS-EXT-STS:vm_state": "active",
#           "accessIPv4": "0.0.0.0",
#           "addresses": {
#               "private": [
#                   {
#                       "addr": "0.0.0.0",
#                       "version": 4
#                   }
#               ],
#               "public": [
#                   {
#                       "addr": "1.1.1.1",
#                       "version": 4
#                   }
#               ],
#           },
#           "config_drive": "",
#           "created": "2013-12-09T16:47:16Z",
#           "flavor": {
#               "id": "YOUR-FLAVOR-ID",
#               "links": [
#                   {
#                       "href": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/flavors/YOUR-FLAVOR-ID",
#                       "rel": "bookmark"
#                   }
#               ]
#           },
#           "hostId": "babcfefdbe6d59077f4f7346fbeca3937f9345c50e59945e9bf9f15a",
#           "id": "YOUR-SERVER-ID",
#           "image": {
#               "id": "YOUR-IMAGE-ID",
#               "links": [
#                   {
#                       "href": "https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/images/YOUR-IMAGE-ID",
#                       "rel": "bookmark"
#                   }
#               ]
#           },
#           "key_name": null,
#           "name": "YOUR-SERVER-NAME",
#           "progress": 100,
#           "status": "ACTIVE",
#           "tenant_id": "407382",
#           "updated": "2013-12-09T16:48:37Z",
#           "user_id": "12148"
#       }
#   }



# The final step in this process is to delete your server.
# Here you will need YOUR-SERVER_ID to delete the instance.
curl https://YOUR-DATA-CENTER.servers.api.rackspacecloud.com/v2/YOUR-TENANT-ID/servers/YOUR-SERVER-ID -X DELETE -H "X-Auth-Project-Id: YOUR-USER-NAME" -H "Accept: application/json" -H "X-Auth-Token: YOUR-TOKEN-ID"


