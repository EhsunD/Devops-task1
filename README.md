# dotin-devops-task1
First task of Devops, about operation system

Step1:
  Write a simple API that echos everything you send to it! Also, write the sent message on a file in the /var/lib/echo_api/{message}

Step2:
  Write a service file for this API. Whenever the reboots, this service should be started automatically.

Step3:
  Write a script that works as a backup manager.
  Commands:
    - bm --schedule|-s {crontab_format} {src_path} {des_path} (Setup a new backup)
    - bm --list (Show list of configured backups)
    - bm --older-than {time_period} --housekeeping {backup_id} (Delete backups older than given period)
    - bm --help|-h (show help)

Step4:
  Set up a backup for your API with your script!
  Backup from your API data every 12:30 on even days.
