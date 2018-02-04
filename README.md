# Github Activity Tracker
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

* A shell script which returns the last activity days of
* a github user and sends a mail to specified mailbox
* Sample: %githubuser: Last active 15 day(s) ago
* Uses public activity from Github.

## Pre-Requisites
+ A configured postfix or any MTA
+ Github accounts
+ [jq](https://stedolan.github.io/jq/) for json parsing (may need to be compiled from source)

## Usage
1. Fill the text file usersandmails.txt with github ids
space separated to the corresponding email ads for notifications:
e.g. githubuser myemailad@email.com

2. Configure the local postfix account to be used.

3. ./github_activity_tracker.sh - running the script will do the job.

4. Note: activity.txt is a text file that stores temporary results for sending mails.

## Author
* Codarren Velvindron (codarren@hackers.mu)
* For questions and suggestions kindly send me a mail
* or open an issue
