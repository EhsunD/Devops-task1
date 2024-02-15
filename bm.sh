#!/bin/bash

BACKUP_DIRECTORY="/path/to/backup/dir"
BACKUP_LOG_FILE="/path/to/backup/logfile.txt"
BACKUP_LOG_SEC="/path/to/backup/seqfile.txt"

setup_new_backup() {
    local crontab_format="$1"
    local src_path="$2"
    local des_path="$3"
		local temp="$(tail -n 1 $BAC_LOG_SEQ)"
    readonly c=1
		result=$((temp+c)) 
    
    echo "$crontab_format $src_path $des_path" >> "$BACKUP_LOG_FILE"
		echo "$result" >> "$BAC_LOG_SEQ"
		
		crontab -l > mycron
		#echo new cron into cron file
		echo "$1 bm --backup 1" >> mycron
		#install new cron file
		crontab mycron
		rm mycron
    
    echo "New backup has been scheduled."
}

list_backups() {
    if [[ -f "$BACKUP_LOG_FILE" ]]; then
        echo "Configured backups:"
        cat "$BACKUP_LOG_FILE"
    else
        echo "No backups configured."
    fi
}

perform_backup() {
    local backup_id="$1"
    
    if [[ -f "$BACKUP_LOG_FILE" ]]; then
        local backup_entry=$(sed -n "${backup_id}p" "$BACKUP_LOG_FILE")
        
        if [[ -n "$backup_entry" ]]; then
            #local crontab_format=$(echo "$backup_entry" | awk '{print $1}')
            local src_path=$(echo "$backup_entry" | awk '{print $2}')
            local des_path=$(echo "$backup_entry" | awk '{print $3}')
            
            local timestamp=$(date +"%Y%m%d%H%M%S")
            local backup_dir="$des_path/backup_$timestamp"
            
            cp -R "$src_path" "$backup_dir"
            
            echo "Backup completed successfully."
        else
            echo "Invalid backup ID."
        fi
    else
        echo "No backups configured."
    fi
}

delete_old_backups() {
    local time_period="$1"
    local backup_id="$2"
    
    if [[ -f "$BACKUP_LOG_FILE" ]]; then
        local backup_entry=$(sed -n "${backup_id}p" "$BACKUP_LOG_FILE")
        
        if [[ -n "$backup_entry" ]]; then
            local des_path=$(echo "$backup_entry" | awk '{print $3}')
            
            local threshold_date=$(date -d "$time_period days ago" +"%Y%m%d%H%M%S")
            
            find "$des_path" -type d -name "backup_*" | while read -r backup_dir; do
                local backup_timestamp=$(basename "$backup_dir" | cut -d '_' -f 2)
                if [[ $backup_timestamp -lt $threshold_date ]]; then
                    rm -rf "$backup_dir"
                fi
            done
            
            echo "Old backups have been deleted."
        else
            echo "Invalid backup ID."
        fi
    else
        echo "No backups configured."
    fi
}

show_help() {
    echo "Backup Manager Help:"
    echo "bm --schedule {crontab_format} {src_path} {des_path} (Setup a new backup)"
    echo "bm --list (Show list of configured backups)"
    echo "bm --backup {backup_id} (Perform a backup)"
    echo "bm --older-than {time_period} --housekeeping {backup_id} (Delete backups older than given period)"
    echo "bm --help (Show help)"
}

if [[ "$1" == "--schedule" || "$1" == "-s" ]]; then
    setup_new_backup "$2" "$3" "$4"
elif [[ "$1" == "--list" ]]; then
    list_backups
elif [[ "$1" == "--backup" ]]; then
    perform_backup "$2"
elif [[ "$1" == "--older-than" && "$3" == "--housekeeping" ]]; then
    delete_old_backups "$2" "$4"
elif [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
else
    echo "Invalid command. Use --help for assistance."
fi
