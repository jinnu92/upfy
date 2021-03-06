#!/usr/bin/env bash

set -e

grey='\033[0;37m'
green='\033[0;32m'
nc='\033[0m'

scripts_url=https://raw.githubusercontent.com/rousan/upfy/master/dist/scripts.zip
app_folder=$(eval echo ~$USER)/.upfy
bashrc_file=$(eval echo ~$USER)/.bashrc

print_grey() {
  printf "${grey}${1}${nc}"
}

print_green() {
  printf "${green}${1}${nc}"
}

download_scripts() {
  # create tempfile
  tmpfile=$(mktemp /tmp/upfy-scripts-download.XXXXX)

  # dowbload scripts zip
  curl -s -o "$tmpfile" "$scripts_url"

  # create scripts folder if not exists
  scripts_folder=$app_folder/scripts
  mkdir -p "$scripts_folder"

  # unzip the downloaded zip inside scripts folder
  unzip -o "$tmpfile" -d "$scripts_folder"

  # delete tempfile
  rm "$tmpfile"
}

printf "\n"
print_grey "  Downloading scripts: "
print_green "$scripts_url"
printf "\n"
download_scripts >/dev/null

[[ -f "$bashrc_file" ]] || touch "$bashrc_file"

print_grey "  Appending commands to bashrc file: "
print_green "$bashrc_file"
main_script_file=$app_folder/scripts/main.sh
execute_line=$(echo "[ -f $main_script_file ] && source $main_script_file")
if ! grep -Fxq "$execute_line" "$bashrc_file"
then
  printf "\n" >> "$bashrc_file"
  printf "# added by Upfy\n" >> "$bashrc_file"
  printf "$execute_line" >> "$bashrc_file"
  printf "\n" >> "$bashrc_file"
fi

printf "\n"
print_green "  Done!"

printf "\n\n"
print_grey "  It is recommended to execute following command once:"
printf "\n"
print_green "  $ source $bashrc_file"
printf "\n\n"