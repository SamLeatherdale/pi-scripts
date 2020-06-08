#!/usr/bin/python3
import requests

# "https://nordvpn.com/what-is-my-ip/"
contents = requests.get("https://nordvpn.com/wp-admin/admin-ajax.php?action=get_user_info_data")
print(contents.json())
if contents.json().get('status'):
    print("Verified: Your internet traffic is secure")
else:
    print("Your internet traffic is not secure")