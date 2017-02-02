function! CFSubmit(probCode) "{{{
python << EOF
import vim
prob = vim.eval('a:probCode')
code = vim.eval("expand('%:p')")
import requests
from BeautifulSoup import BeautifulSoup as bs
import sys
import os
URLSubmit = "http://codeforces.com/problemset/submit"
URLLogin = "http://codeforces.com/enter"
cliente = requests.session()
r = cliente.get(URLLogin)
html = r.content
soup = bs(html)
head = soup.head
meta = head.findChildren('meta')


csrf_token = meta[1]["content"]


payload1 = {
		'csrf_token' : csrf_token,
		'action':'enter',
		'handle':'YourHandle',
		'password':'YourPassword'
		 
	   }

header = {
		'Referer' : URLLogin,
		'User-agent' : 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/601.2.4 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.4'
	}

parts = {
    "csrf_token":            csrf_token,
    "action":                "submitSolutionFormSubmitted",
    "submittedProblemCode":  prob,
    "source":                open(code,"rb").read(),
    "sourceFile":            "",
    "programTypeId":         'depends on language',
    "toggleEditorCheckbox":  "",
    "_tta": 		     "208"
    
}

r=cliente.post(URLLogin,data=payload1,headers=header);
with open("requests_results.html", "w") as f:
	    f.write(r.content)
	    f.close()


r=cliente.post(URLSubmit,data=parts,headers=header)
with open(os.path.expanduser("~/programming/submission.html"),"w") as f:
	f.write(r.content)
	f.close()
print "Submission Successfull"

	
EOF

endfunc
"}}}

function! CFLastVerdict()
	pyfile ~/path/to/checker.py
endfunc

command! -nargs=1  CodeForceSubmit  call  CFSubmit(string(<q-args>))
command! LastVerdict call CFLastVerdict()
