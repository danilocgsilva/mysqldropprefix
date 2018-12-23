#!/bin/bash

## version
VERSION="1.0.0"

set -e


## Checks if mysql_config_editor exists in the system
check_mysql_config_editor() {
  if [ ! which mysql_config_editor ] > /dev/null 2>&1; then
    echo 'You must have the mysql_config_editor utility installed to preceed. Canceling'
    exit
  fi
}

## Asks for login path
asks_login_path() {
  read -p "Please, provides the login-path: " loginpath
}

## Asks for database prefix
asks_database_prefix() {
  read -p "Please, provides the database prefix: " databaseprefix
}

## Asks for database table
asks_database_table() {
  read -p "Please, provides the database name: " databasename
}

## Message before listing the tables
message_tables_list() {
  echo "Those are the tables that will be wipped out from the database..."
  echo "--//--"
}

## Fills the tables informations
fill_tables_infos() {
  tables_list=($(mysql --login-path=$loginpath $databasename -e "SHOW TABLES" | sed 1d | grep -iE "$databaseprefix"))
}

## Shows the user and address data
show_address_data() {
  echo "--//--"
  echo "Data from: $(mysql --login-path=$loginpath -e "SELECT USER()" | sed 1d)"
}

## Shows tables with prefix
shows_prefixed_tables() {
  message_tables_list
  for i in "${tables_list[@]}"; do
    echo $i tabela
  done
  show_address_data
  echo "--//--"
}

## Conform the database prefix removing
confirm_remove() {
  echo "ARE YOU SURE TO CLEAN OUT THOSE TABLES? THIS ACTION CANT BE UNDONE!!!"
  read -p "Type (yes). Otherwise, skips the script: " suretoremove
}

## Remove definitive
remove_definitive() {
  for i in "${tables_list[@]}"; do
    mysql --login-path=$loginpath $databasename -e "DROP TABLE $i"
    echo $i dropped.
  done
}

## Removes definitivelly the tables
remove_prefixed_tables() {
  if [ ! -z $suretoremove ] && [ $suretoremove = yes ]; then
    remove_definitive
  else
    echo The user skped the remotion.
  fi
}

## Main function
mysqldropprefix () {
  local loginpath
  local databaseprefix
  local databasename
  local suretoremove
  local tables_list

  check_mysql_config_editor
  asks_login_path
  asks_database_prefix
  asks_database_table
  fill_tables_infos
  shows_prefixed_tables
  confirm_remove
  remove_prefixed_tables
}

## detect if being sourced and
## export if so else execute
## main function with args
if [[ /usr/local/bin/shellutil != /usr/local/bin/shellutil ]]; then
  export -f mysqldropprefix
else
  mysqldropprefix "${@}"
  exit 0
fi
