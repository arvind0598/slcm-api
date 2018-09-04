# slcm-api

API for SLCM made using:
* NodeJS and ExpressJS for Backend.
* Postman for the actual API collection.
* Python3 with BeautifulSoup for data processing.

---

## WARNING

This is currently under development and is my first back-end project.
It is extremely insecure to use on a larger scale, and I'd like help in getting it faster and more secure.
Plus there's very poor error handling, please help out there.

---

## INSTRUCTIONS

Set up a LAMP stack on your system.

#### First Time Setup

First run ```yarn add``` to install dependencies.

Start the server using ```yarn start```.

Send a GET request to ```localhost:8080/createDatabase``` to make the database and tables.

_NOTE: the above route is not made yet. You'll find the PHPMyAdmin dump at src/mysql/_

##### Getting API KEY

Send a GET request to ```localhost:8080/registerClient``` to get the API KEY.

##### Logging in per end-user

Submit a POST request to ```localhost:8080/setData```.
Should contain:  _key_, _username_ and _password_ fields.
I used the __x-www-form-urlencoded__ option on postman.
This initializes the ```cred.json``` file.

Submit an POST request with the key to ```localhost:8080/updateData```.
This will run the collection and create the ```data``` folder within ```src```.

#### Fetching Data

There are three routes that return JSONS when you send a POST request with a valid key.

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