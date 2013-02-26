I Am Alive Clients
===================

I'd prefer to have scripts that check-in automatically. For now, do it yourself
with these commands. Schedule them with cron or Task Scheduler.

Linux, OS X
------------

    curl -X POST --data "organization_name=$ORG_NAME&computer_name=$(hostname)" http://iamalive.herokuapp.com/checkin

Windows
--------

PowerShell:

    (New-Object Net.WebClient).UploadString(
        "http://iamalive.herokuapp.com/checkin",
        "POST",
        "organization_name=$ORG_NAME&computer_name=$($env:computername)")
