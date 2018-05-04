# slcm-api

API for SLCM made using:
* NodeJS and ExpressJS for Backend.
* Postman for the actual API collection.
* Python3 with BeautifulSoup for data processing.

---

## WARNING

This is currently under development and is my first back-end project.
It is extremely insecure to use on a larger scale, and I'd like help in getting it faster and more secure.

---

## INSTRUCTIONS

First run ```npm install``` or ```yarn add``` to install dependencies.
Start the server using ```node script.js ```.

#### First Time Setup

Submit a POST request to ```localhost:8080/setData```, that contains _username_ and _password_ fields.
I used the __x-www-form-urlencoded__ option on postman.
This initializes the ```cred.json``` file.

Submit an empty POST request to ```localhost:8080/updateData```.
This will run the collection and create the ```data``` folder within ```src```.

#### Fetching Data

There are three routes that return JSONS when you send a POST request
1. ```localhost:8080/getCourses```
	
	```
	{
		subject_code1: subject_name1
		subject_code2: subject_name2
		subject_coden: subject_namen
	}
	```

2. ```localhost:8080/getMarks```

	```
	{
		subject_code1: {
			marks_total:
			marks_got:
		},
		subject_code2: {
			marks_total:
			marks_got:
		},
		subject_coden: {
			marks_total:
			marks_got:
		}
	}
	```

3. ```localhost:8080/getAttendance```

	```
	{
		subject_code1: {
			total:
			present:
		},
		subject_code2: {
			total:
			present:
		},
		subject_coden: {
			total:
			present:
		}
	}