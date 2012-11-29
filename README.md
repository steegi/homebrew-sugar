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
If your MAMP installation is modified, see the Usage section on how to supply a custom config_si.php template.

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

### Using a custom config_si.php template
If you don't want to use a standard MAMP installation or a different setup all together, you can now supply your own config_si.php template through the SGRBREW_CONFIG_SI_TEMPLATE environment variable. You set it like this in bash or ksh:
```
export SGRBREW_CONFIG_SI_TEMPLATE=~/tmp/sgrbrew_config_si_template.php
```
There are 3 variables available in the template:
* instance_name: The name associated with the formula, which is typically used for naming the database
* app_url: The combined URL based on the default values
* demo_data: Whether or not the --with-demo-data was specified on the command line.

Example template:
```php
<?php
  $sugar_config_si = array (
    'setup_db_host_name' => 'localhost',
    'setup_db_database_name' => '#{instance_name}',
    'setup_db_drop_tables' => true,
    'setup_db_create_database' => true,
    'setup_site_admin_user_name' => 'admin',
    'setup_site_admin_password' => 'asdf',
    'setup_db_create_sugarsales_user' => false,
    'setup_db_admin_user_name' => 'root',
    'setup_db_admin_password' => 'root',
    'setup_site_url' => '#{app_url}',
    'dbUSRData' => 'provide',
    'setup_db_type' => 'mysql',
    'setup_system_name' => 'SugarCRM',
    'default_currency_iso4217' => 'USD',
    'default_currency_name' => 'US Dollars',
    'default_currency_significant_digits' => '2',
    'default_date_format' => 'm/d/Y',
    'default_time_format' => 'h:ia',
    'default_decimal_seperator' => '.',
    'default_export_charset' => 'UTF-8',
    'default_language' => 'en_us',
    'default_locale_name_format' => 's f l',
    'default_number_grouping_seperator' => ',',
    'export_delimiter' => ',',
    'demoData' => '#{demo_data}',
    'setup_site_sugarbeet_anonymous_stats' => '1',
    'setup_site_sugarbeet_automatic_checks' => '1',
    'setup_site_specify_guid' => '0',
    'setup_site_guid' => 'auto',
    );
```


### Uninstalling Sugar brews
Uninstalling Sugar brews is just as simple as installing them.
```
brew uninstall steegi/sugar/sgr657ce
```
Uninstalling a Sugar brew will remove all the files but not the database. Note though that a new install of the same formula will wipe the database. Hence to start over with a clean slate just simply uninstall and install the formula.

If for any reasons you would only want to remove an instance from the web server but not uninstall it, just use the Homebrew unlink command and link to add it back.