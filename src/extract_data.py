from bs4 import BeautifulSoup, element
import json
import itertools

def chunks(a, n):
	for i in range(0, len(a), n):
		yield a[i:i + n]

file = open("report.html")
soup = BeautifulSoup(file, "html.parser")

tr = soup.find_all("tr")
content = [i.get_text().strip().split("\n") for i in tr if len(i.get_text().strip()) > 0]
content = content[:170]
num_courses = len(soup.find(id = "tblAttendancePercentage").find_all("tr")) - 1
course_codes = [i[0].replace(" ","") for i in content[1:num_courses + 1]]
course_names = [i[1] for i in content[1:num_courses + 1]]
courses = dict(zip(course_codes, course_names))

file = open("./data/courses.json", "w")
file.write(json.dumps(courses))
file.close()

"""TO CALCULATE MARKS"""

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

file = open("./data/marks.json", "w")
file.write(json.dumps(marks))
file.close()

"""TO CALCULATE ATTENDANCE"""

att = dict()
att_arr = content[num_courses + 1 : 2 * (num_courses + 1)]
for i in att_arr[1:]:
	i[2] = i[2].replace(" ","")
	sub_att = dict()
	sub_att["total"] = i[4]
	sub_att["present"] = i[5]
	att[i[2]] = sub_att

file = open("./data/att.json", "w")
file.write(json.dumps(att))
file.close()
