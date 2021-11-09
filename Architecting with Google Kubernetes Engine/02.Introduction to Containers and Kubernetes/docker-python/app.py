### all comments are in English
### because sometimes korean comments throw errors though they're just comments


import sys
import requests
from bs4 import BeautifulSoup

url="https://senticoding.tistory.com/49" # url to send HTTP request
headers={"user-agent":"docker_tutorial"}
print(sys.version) # to check out what version of python I am using
# rq is a variable to save the HTTP request
# pass "user-agent" to prevent to be blocked by things like robot
rq=requests.get(url, headers=headers)

#soupObject is a beautifulsoup object
soupObject=BeautifulSoup(rq.content, 'html.parser', from_encoding="utf-8")

# print(rq.status_code) #status_code should be 200 which means a success

print(soupObject.select(".tit_post a"))	# print the title of bs based on the request

# result should be 
# the title of the post in the url
# like
"""
[[Docker] Get started with Docker. What is Docker?]
"""