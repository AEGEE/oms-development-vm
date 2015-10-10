## Snippets

This repo contains an example of how was the interfacing to the LDAP before the introduction of the REST API (note: without a framework). Find them in the branch "old".

It also contains the example on how the API are meant to be used and how this architecture allows for loosely coupled services.

# Usage

Place the folder in the served folder of your webserver (according to the Vagrantfile is in the home of the project, called /serve). Then navigate to <yourIP>:8888 and the index will show you the choices. Don't forget to ask questions if you have problems. Also last thing, modify in the ```.php``` files the IP address of your webserver. This was just a quick PoC, not meant to be something polished. Also we're not gonna use PHP anyway. Ask if you're confused!

## Possible scenario

Say you are an AEGEEan that wants to register, you can pass through the map page, click on a local, and click that you want to apply as member of that local. 
The page will bring you then to a form where you insert your data, when you finally click on the submit button you will be registered.
Alternatively, you can directly go to the details page (example real-life situation: your browser doesn't support the map for some reason). Then the user enters the details and also has to check from the dropdown list which is the antenna s/he wants to apply to

### Site map/sequence of the pages

```
Index
|---> Showrecord.php
|---> register.html (the map page) ---> details.php (fill in other details) ---> useradd.php (simple php that sends in info, the only output is the name of the added person)
\---> details.php ---> useradd.php   (as above, without the map step)
```
