homebrew-sugar
==============
A Homebrew Tap repository for SugarCRM related brews

## Purpose and limitations

The purpose of these brews is to quickly install and test SugarCRM releases and plug-ins/modules under a variety of conditions. They are not intended and should not be used for production purposes. Moreover anyone using these brews assumes responsiblity for any and all side affects of the proposed changes and modifications to the system as well as those made by the invidual brews.

## Getting started

### Pre-requisites
All SugarCRM formulas except those for the community editions (CE) require a connection to the SugarCRM corporate network (VPN or directly) as the release archives are only accessible from inside the corporate network.

### MAMP

These brews all depend on a standard, working MAMP installation with the default user name and password in tact.
If you don't currently have MAMP install, you can download the free or Pro version from here: http://www.mamp.info/en/index.html

All brews will install in /usr/local/share and depend on this location being available via http://localhost:8888/share. Hence for the default MAMP install we can achieve this by symbolicly linking /usr/local/share like this in a terminal window:

```
ln -s /usr/local/share /Applications/MAMP/htdocs
```
Note that we are not using virtual directories to avoid having to deal with configuring subdirectory .htaccess files and redirections. With a symbolic link and the default configuration and the Sugar installer provided .htaccess file we are all set.

### Homebrew
To get started you first need Homebrew. It can be installed like so:
```
ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
```
The last step is to install this repository as a Homebrew tab but running this from the command line:
```
brew tap steegi/homebrew-sugar
```

## Usage

### Installing Sugar brews

The brews in this repository assume that MAMP is installed with the defaults as mentioned earlier. They create their own database and subdirectories following the naming scheme of the formula itself.

I.e. When we install SugarCRM community edition 6.5.8 like so
```
brew install steegi/sugar/sgr657ce
```
The installer will drop all tables and install into a database named 'sgr657ce'. If it doesn't exist, it will create it. The application will be available from http://localhost:8888/share/sgr657ce.

### Configuration options
Currently all these brews support 3 options
* --without-config_si: Only extracts the files (implies --without-sugar-install) and thus will not generate a config_si.php file.
* --without-sugar-install: Installs the files and creates the config_si but does not run the Sugar installer (implies --without-config_si is not specified). I.e. this gives the user the opportunity to update the generated config_si.php file before hitting the instance which will trigger the silent installer.
* --with-demo-data: Installs and creates demo data in the database

Example:
```
brew install steegi/sugar/sgr657ce --with-demo-data
```

### Uninstalling Sugar brews
Uninstalling Sugar brews is just as simple as installing them.
```
brew uninstall steegi/sugar/sgr657ce
```
Uninstalling a Sugar brew will remove all the files but not the database. Note though that a new install of the same formula will wipe the database. Hence to start over with a clean slate just simply uninstall and install the formula.

If for any reasons you would only want to remove an instance from the web server but not uninstall it, just use the Homebrew unlink command and link to add it back.