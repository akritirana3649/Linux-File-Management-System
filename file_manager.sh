#!/bin/bash

# Linux File Management System
# BCA Linux Practical Project

LOG="activity.log"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG"
}

while true
do
    echo ""
    echo "======================================"
    echo "     LINUX FILE MANAGEMENT SYSTEM"
    echo "======================================"
    echo "1. Create File"
    echo "2. Delete File"
    echo "3. Create Directory"
    echo "4. List Files"
    echo "5. Search File"
    echo "6. Copy File"
    echo "7. Change File Permissions"
    echo "8. Write to File"
    echo "9. Read File"
    echo "10. Move File"
    echo "11. Backup File"
    echo "12. Restore File"
    echo "13. View Activity Log"
    echo "14. Exit"
    echo "======================================"

    read -p "Enter your choice: " choice

    case $choice in
    1)
        read -p "Enter filename: " file
        if [ -e "$file" ]; then
            echo "File already exists!"
        else
            touch "$file"
            echo "File created successfully!"
            log_action "Created file: $file"
        fi
        ;;
    2)
        read -p "Enter filename: " file
        if [ -f "$file" ]; then
            rm -i -- "$file"
            if [ ! -e "$file" ]; then
                echo "File deleted!"
                log_action "Deleted file: $file"
            fi
        else
            echo "File not found!"
        fi
        ;;
    3)
        read -p "Enter directory name: " dir
        mkdir -p -- "$dir"
        echo "Directory created successfully!"
        log_action "Created directory: $dir"
        ;;
    4)
        ls -lah
        ;;
    5)
        read -p "Enter filename to search: " file
        find . -type f -name "$file" -not -path "./Backups/*"
        ;;
    6)
        read -p "Enter source filename: " source
        read -p "Enter destination filename: " dest
        if [ -f "$source" ]; then
            cp -i -- "$source" "$dest"
            echo "Copy operation completed!"
            log_action "Copied $source to $dest"
        else
            echo "Source file not found!"
        fi
        ;;
    7)
        read -p "Enter filename: " file
        read -p "Enter permission (example 755): " perm
        if [ -f "$file" ] && [[ "$perm" =~ ^[0-7]{3,4}$ ]]; then
            chmod "$perm" -- "$file"
            echo "Permissions updated!"
            ls -l -- "$file"
            log_action "Changed permissions of $file to $perm"
        else
            echo "Invalid file or permission!"
        fi
        ;;
    8)
        read -p "Enter filename: " file
        if [ -f "$file" ]; then
            read -r -p "Enter content: " content
            printf '%s\n' "$content" >> "$file"
            echo "Content saved!"
            log_action "Wrote content to $file"
        else
            echo "File not found! Create it first."
        fi
        ;;
    9)
        read -p "Enter filename: " file
        if [ -f "$file" ]; then
            cat -- "$file"
            log_action "Read file: $file"
        else
            echo "File not found!"
        fi
        ;;
    10)
        read -p "Enter source filename: " source
        read -p "Enter destination path: " dest
        if [ -f "$source" ]; then
            mv -i -- "$source" "$dest"
            echo "Move operation completed!"
            log_action "Moved $source to $dest"
        else
            echo "Source file not found!"
        fi
        ;;
    11)
        read -p "Enter filename to backup: " file
        if [ -f "$file" ]; then
            mkdir -p Backups
            backup="Backups/$(basename "$file").$(date +%Y%m%d_%H%M%S).bak"
            cp -- "$file" "$backup"
            echo "Backup created: $backup"
            log_action "Backed up $file"
        else
            echo "File not found!"
        fi
        ;;
    12)
        echo "Available backups:"
        ls -1 Backups/ 2>/dev/null
        read -p "Enter backup filename: " backup
        if [ -f "Backups/$backup" ]; then
            read -p "Enter restore destination filename: " dest
            if [ -e "$dest" ]; then
                echo "Destination already exists. Choose another name."
            else
                cp -- "Backups/$backup" "$dest"
                echo "File restored successfully!"
                log_action "Restored $backup to $dest"
            fi
        else
            echo "Backup not found!"
        fi
        ;;
    13)
        if [ -f "$LOG" ]; then
            cat "$LOG"
        else
            echo "No activity recorded yet."
        fi
        ;;
    14)
        echo "Thank you for using Linux File Management System!"
        log_action "Exited the application"
        break
        ;;
    *)
        echo "Invalid choice! Please try again."
        ;;
    esac
done
