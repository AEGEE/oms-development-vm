# README #

### What is this repository for? ###

Simple LDAP server with Vagrant and Puppet as proof-of-concept of these technologies.

### How do I get set up? ###

* Install [Vagrant](https://www.vagrantup.com/downloads.html).
* Clone this repository _recursively_ with ```git clone --recursive <URL>```.
* Start the virtual machine with ```vagrant up``` from within the repository folder.
* Visit phpLDAPadmin at http://localhost:8080/phpldapadmin in a browser.

If you use Windows, make sure you have LF line endings in git. You also have to fix symlinks after cloning! See this for more info:

* http://stackoverflow.com/questions/5917249/git-symlinks-in-windows
* https://help.github.com/articles/dealing-with-line-endings/