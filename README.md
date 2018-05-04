# slcm-api

API for SLCM made using NodeJS, Python and Postman.

---

### WARNING

This is currently under development, it is extremely insecure to use on a larger scale, and I'd like help in getting it secure.
Also, be careful when you commit as the credentials are copied into __SLCM.postman_collection.json__

---

## Instructions

Start the server using ```node script.js ```.

#### First time use

Submit a POST request to ```localhost:8080/setData```, that contains _username_ and _password_ fields. I used the __x-www-form-urlencoded__ option on postman.
This initializes the ```cred.json``` file.

Submit an empty POST request to ```localhost:8080/data/update```.
This will run the collection, and create the jsons in the data folder.


#### Fetching data

There are three routes that return data when you submit an empty POST request
1. ```localhost:8080/getCourses```
2. ```localhost:8080/getMarks```
3. ```localhost:8080/getAttendance```