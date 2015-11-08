# README #

### What is this repository for? ###

Simple LDAP server with Vagrant and Puppet as proof-of-concept of these technologies.

### How do I get set up? ###

* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and
  [Vagrant](https://www.vagrantup.com/downloads.html).
* Clone this repository _recursively_ with ```git clone --recursive <URL>```.
* If you use Windows, fix your line endings now (see below).
* Start the virtual machine with ```vagrant up``` from within the repository folder.
* Visit phpLDAPadmin at http://localhost:8888/phpldapadmin in a browser.
* If you want to use ApacheDirectoryStudio, use server at localhost:4444.

### Remarks for Windows hosts ###

If you use Windows as host (i.e., as development platform), you have to be cautious about a few things:

* Be careful about too long filenames. Either clone at a high point of your folder structure (for example at `C:\aegee`), or use `git config --system core.longpaths true`(with Git 1.9.0 and above). See [here](http://stackoverflow.com/questions/22575662/filename-too-long-in-git-for-windows) for details.
* You MUST use LF line endings in git. This is true for all submodules as well! See [this article](https://help.github.com/articles/dealing-with-line-endings/) for details. These commands should do the trick:
```
    git config core.autocrlf false
    git config core.eol lf
    git submodule foreach --recursive "git config core.autocrlf false"
    git submodule foreach --recursive "git config core.eol lf"
    rm -rf *     # Careful: you know what this does!
    git checkout -- .
    git submodule update --recursive
```
* You also have to fix symlinks after cloning! See [this article](http://stackoverflow.com/questions/5917249/git-symlinks-in-windows) for more info.
