from BeautifulSoup import BeautifulSoup as bs
import requests

html = requests.get("http://codeforces.com/api/user.status?handle=YourHandle&from=1&count=1").json()['result']
print html[0]['verdict']
