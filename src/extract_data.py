from bs4 import BeautifulSoup
from os import remove, path, makedirs
import json
import itertools

""" CHUNKS breaks up a list a into groups of length n """

def chunks(a, n):
	for i in range(0, len(a), n):
		yield a[i:i + n]

#create the directory if it does not exist
if not path.exists("./data"):
	makedirs("data")

#open the html file and parse it with beautifulSoup
file = open("report.html")
soup = BeautifulSoup(file, "html.parser")
file.close()

#get content from page
tr = soup.find_all("tr")
content = [i.get_text().strip().split("\n") for i in tr if len(i.get_text().strip()) > 0]
content = content[:170]

#get extra details that help later
num_courses = len(soup.find(id = "tblAttendancePercentage").find_all("tr")) - 1
course_codes = [i[0].replace(" ","") for i in content[1:num_courses + 1]]
course_names = [i[1] for i in content[1:num_courses + 1]]
courses = dict(zip(course_codes, course_names))

"""
TO WRITE COURSES:
	returns a dict with:
		key = course code
		value = course name
"""

file = open("./data/courses.json", "w+")
file.write(json.dumps(courses))
file.close()

"""
TO CALCULATE MARKS:
	returns a dict with:
		key = course code
		value = {
			key = marks_total
			key = marks_got
		}
"""

marks = dict()

for i in course_codes:
	details = soup.find("div", id=i).find_all("td")
	stuff = [k.get_text().strip() for k in details if len(k.get_text().strip()) > 0]
	cleaned_stuff = list(chunks(stuff, 3))
	course_marks = dict()
	for x in cleaned_stuff:
		indiv_marks = dict()
		indiv_marks["marks_total"] = x[1]
		indiv_marks["marks_got"] = x[2]
		course_marks[x[0]] = indiv_marks 
	marks[i] = course_marks

file = open("./data/marks.json", "w+")
file.write(json.dumps(marks))
file.close()

"""
TO CALCULATE ATTENDANCE
	returns a dict with:
		key = course code
		value = {
			key = total
			key = present
		}
"""

att = dict()
att_arr = content[num_courses + 1 : 2 * (num_courses + 1)]
for i in att_arr[1:]:
	i[2] = i[2].replace(" ","")
	sub_att = dict()
	sub_att["total"] = i[4]
	sub_att["present"] = i[5]
	att[i[2]] = sub_att

file = open("./data/att.json", "w+")
file.write(json.dumps(att))
file.close()

remove("./report.html")