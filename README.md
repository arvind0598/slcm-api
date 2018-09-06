# slcm-api

API for SLCM made using:
* NodeJS and ExpressJS for Backend.
* node-html-parser with for data processing.

An earlier version was made that used BeautifulSoup with Python and a Newman script to do the same thing, but this works a lot faster so I switched over.

---

## WARNING

This is currently under development and is my first back-end project.
It is extremely insecure to use on a larger scale, and I'd like help in getting it faster and more secure.
Plus there's very poor error handling, please help out there.

Ps. SLCM does not have marks yet.

---

#### Fetching Data

```
{
	username : 160953104
	password : password
}
```

Send a x-www-form-urlencoded POST request of the above format to ```locahost:8080/api``` and get:

```
{
    "error": false,
    "name": "ARVIND S",
    "courses": {
        "ICT3161": {
            "name": "RATIONAL UNIFIED PROCESS LAB",
            "sem": "V",
            "cred": "1.00"
        },
        "ICT3162": {
            "name": "DATABASE SYSTEMS LAB",
            "sem": "V",
            "cred": "2.00"
        },
        "ICT3151": {
            "name": "FUNDAMENTALS OF ALGORITHM ANALYSIS AND DESIGN",
            "sem": "V",
            "cred": "3.00"
        },
        "ICT3152": {
            "name": "HIGH SPEED COMMUNICATION NETWORKS AND PROGRAMMING",
            "sem": "V",
            "cred": "4.00"
        }
    },
    "marks": {},
    "att": {
        "ICT3151": {
            "present": "13",
            "total": "13"
        },
        "ICT3152": {
            "present": "17",
            "total": "20"
        },
        "ICT3153": {
            "present": "14",
            "total": "15"
        },
        "ICT3154": {
            "present": "10",
            "total": "12"
        }
    }
}
```

There is a ```status``` field that will be present if the ```error``` field is true, that explains why the error happened.
