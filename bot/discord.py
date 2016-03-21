import json
import requests
import sys

if len(sys.argv) < 4:
    sys.exit()
   
headers = {"Authorization" : sys.argv[1]}

payload = {'content' : sys.argv[3]}

r = requests.post(url='https://discordapp.com/api/channels/'+sys.argv[2]+'/messages', data=payload, headers=headers)

print(r.status_code)
