#!/bin/bash
Update(){

    echo "Updating and Installing"
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    echo "finished updating"
    sleep 10
    sudo reboot
}

Clam() {
    echo "Installing Clamtk and running scan"
    sudo apt-get -y install clamtk
    sleep 5
    sudo clamtk

}

Chkprohib() {
    local -a file_extentions=("mp3" "mov" "mp4" "avi" "mpg" "mpeg" "flac" "m4a" "flv" "ogg" "gif" "png" "jpg" "jpeg")

    for ext in "${file_extentions[@]}"; do
        #finds and deletes files
        sudo find / -type f -name "*.$ext" -exec rm {} \;
        echo "deleted files with .$ext extention systemwide"
    done
    sleep 5
}

Firewall(){
    sudo apt-get -y install ufw
    ufw enable
    sleep 5
    ufw status
    sleep 5
}

LightdmUbuntu(){
    local config_file="/usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf"
    #declares settings and values
    settings=("allow-guest" "greeter0hide-users" "greeter-show-manual-login" "autologin-user")
    values=("false" "true" "true" "none")
    #checks if the config file exists
    if [ -e "$config_file" ]; then
        #loops through the arrays
        for ((i=0; i<${#settings[@]}; i++)); do 
        setting=${settings[i]}
        value=${values[i]}
        #checks if the the settings exist
            if grep -q "^$setting=" "$config_file"; then
                #if it exists, changes the value to what it should be
                sed -i "s/^$setting=.*/$setting=$value/" "$config_file"
                echo "Value for setting '$setting' updated in the config file"
            else
                #if the setting doesnt exist add the new setting and coresponding value
                echo "$setting=$value" >> "$config_file"
                echo "New setting '$setting' appended to the config file"
            fi
        done
    else
        echo "Config file not found"
    fi
    sleep 5
}

LightdmDebian(){
    local config_file="/etc/lightdm/lightdm.conf "
    #declares settings and values
    settings=("Greeter-hide-users" "Greeter-allow-guest" "Greeter-show-manual-login" "Allow-guest" "Autologin-user")
    values=("true" "false" "true" "false" "none")
    #checks if the config file exists
    if [ -e "$config_file" ]; then
        #loops through the arrays
        for ((i=0; i<${#settings[@]}; i++)); do 
        setting=${settings[i]}
        value=${values[i]}
        #checks if the the settings exist
            if grep -q "^$setting=" "$config_file"; then
                #if it exists, changes the value to what it should be
                sed -i "s/^$setting=.*/$setting=$value/" "$config_file"
                echo "Value for setting '$setting' updated in the config file"
            else
                #if the setting doesnt exist add the new setting and coresponding value
                echo "$setting=$value" >> "$config_file"
                echo "New setting '$setting' appended to the config file"
            fi
        done
    else
        echo "Config file not found"
    fi
    sleep 5
}

LightdmDeb2(){
    local config_file="/etc/gdm3/greeter.dconf-defaults"
    #declares settings and values
    settings=("Disable-user-list" "Disable-restart-buttons" "AutomaticLoginEnable")
    values=("true" "true" "false")
    #checks if the config file exists
    if [ -e "$config_file" ]; then
        #loops through the arrays
        for ((i=0; i<${#settings[@]}; i++)); do 
        setting=${settings[i]}
        value=${values[i]}
        #checks if the the settings exist
            if grep -q "^$setting=" "$config_file"; then
                #if it exists, changes the value to what it should be
                sed -i "s/^$setting=.*/$setting=$value/" "$config_file"
                echo "Value for setting '$setting' updated in the config file"
            else
                #if the setting doesnt exist add the new setting and coresponding value
                echo "$setting=$value" >> "$config_file"
                echo "New setting '$setting' appended to the config file"
            fi
        done
    else
        echo "Config file not found"
    fi
    sleep 5
}


CreateMisUsrs(){
    read -p "Enter the number of users to create: " num_users
    #checks if the input is >= 0
    if [[ $num_users =~ ^[1-9][0-9]*$ ]]; then
        for ((i=1; i<=$num_users; i++)); do
            read -p "Enter username for user $i: " username
    
            #checks if user already exists
            if id "$username" &>/dev/null; then
                echo "User '$username' already exists. Skipping."
            else
                #creates the new user
                sudo adduser "$username"
                echo "User '$username' created successfully."
            fi
        done
    else
        echo "Invalid input"
    fi
    sleep 5
}

AddRemoveAdmin(){
    declare -a admin_users=()

    while true; do
        read -p "Enter a username to remove admin access or type 'done': "

        if [ "$username" == "done" ]; then
            break
        fi

        admin_users+=("username")
    done

    #gets the list of all users with sudo access
    current_sudo_users=$(getent group sudo | cut -d: -f4)

    #loops through and removes unauthorized users
    for user in $current_sudo_users; do
        if [[ " ${admin_users[@]} " =~ " ${user} "]]; then
            echo "Removed sudo access for '$user'."
        fi
    done

    for user in "${admin_users[@]}"; do
        if sudo id "$user" &>/dev/null; then
            echo "User '$user' already has sudo access."
        else
            sudo adduser "$user" sudo
            echo "Sudo access for '$user' added'"
        fi
    done
    sleep 5
}

Changepass(){
    read -s -p "Enter new password for all users: " new_password
    echo

    if [ -z "$new_password" ]; then
        echo "Password cannot be empty."
        exit 1
    fi

    all_users=$(getent passwd | cut -d: -f1)
    
    for user in $all_users; do
        echo "$user:$new_password" | sudo chpasswd
        echo "Password changed for '$user'."
    done
    sleep 5
}

Logindefs(){
    local -a setting_names=("FAILLOG_ENAB" "LOG_UNKFAIL_ENAB" "SYSLOG_SU_ENAB" "SYSLOG_SG_ENAB" "PASS_MAX_DAYS" "PASS_MAX_DAYS" "PASS_MIN_DAYS" "PASS_WARN_AGE")
    local -a value_names=("YES" "YES" "YES" "YES" "90" "10" "7")

    for ((i=0; i<${#setting_names[@]}; i++)); do
        local setting_name="${setting_names[$i]}"
        local new_value="${new_values[$i]}"

        sudo sed -i "s/^$setting_name[[:space:]]\+.*/$setting_name $new_value/" /etc/login.defs
        echo "Setting '$setting_name' updated to '$new_value'."
    done 
    sleep 5
}

Logindefs2(){
    local file_path="etc/pam.d/common-password"
    local find_set="difok=3"
    local add_set="ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1"

    #check if file exists
    if [ ! -e "$file_path" ]; then
        echo "Error: file not found"
        return 1
    fi

    #finds the appropriate line and adds the new settings at the end
    sudo sed -i "/$find_set\$/ s/\$/ $add_set/" "$file_path"
    echo "New settings added to '$file_path'"
    sleep 5
}

Delusers(){
    while true; do
        read -p "Enter a user that you would like to delete or type 'cancel'" username

        if [ "$username" == "cancel" ]; then
            break
        fi

        if id "$username" &>/dev/null; then
            sudo deluser "$username"
            echo "'$username' deleted"
        else
            echo "'$username' does not exist"
        fi
    done
    sleep 5
}

Backupetcpass(){
    local backup_dir="/etc/backup"
    local backup_file="$backup_dir/passwd_backup_$(date +%Y%m%d%H%M%S).bak"

    #checks if the backup directory exists, creates if it doesnt
    [ -d "$backup_dir" ] || mkdir -p "$backup_dir"
    
    cp /etc/passwd "$backup_file"

    echo "Backup of /etc/passwd created : $backup_file"
    sleep 5
}


Remshbash(){
    programs_with_bash_sh=$(grep -E '/bin/(bash|sh)' /etc/passwd)

    if [ -n "$programs_with_bash_sh" ]; then
        sed -i 's|/bin/\(bash\|sh\)|/usr/bin/false|' /etc/passwd
        echo "removed bash and sh from programs"
    else
        echo "no programs using bash or sh"
    fi
    sleep 5
}

Restorepass(){
    local backup_dir="/etc/backup"
    local latest_backup=$(ls -t "$backup_dir" | head -n 1)

    if [ -n "$latest_backup" ]; then
        read -p "Are you sure you want to restore this file from $latest_backup? (y/n): " confirm

        if [ "$confirm" == "y" ]; then

            #restores the backed up file
            cp "$backup_dir/$latest_backup" /etc/passwd
            echo "Restored file from $latest_backup."
        else
            echo "Restore canceled"
        fi
    else
        echo "No backups found in $backup_dir"
    sleep 5
}

Mangroup(){
    local admin_group="admins"

    #checks if the admin group exists
    if grep -q "^$admin_group:" /etc/group; then

        #gets the list of admins
        local admin_users=$(getent group "$admin_group" | cut -d: -f4)

        if [ -n "$admin_users" ]; then

            #adds admins to the sudo group
            usermod -aG sudo $admin_users

            #adds admins to the adm group
            usermod -aG adm $admin_users

            echo "Added users in $admin_group to sudo and adm groups"
        else
            echo "No users found in $admin_group."
        fi
    else
        echo "Admin group '$admin_group' not found."
    fi
    sleep 5
}

Disrootacc(){
    passwd -l root
    sleep 5
}

Edit_sshid_cofig(){
    local -a settings=("LoginGraceTime" "PermitRootLogin" "Protocol" "PermitEmptyPasswords" "PasswordAuthentication" "X11Fowarding" "UsePAM" "UsePrivilegeSeparation")
    local -a values=("60" "no" "2" "no" "yes" "no" "yes" "yes")

    #checks if the setting exists in the file
    for ((i=0; i<${#settings[@]}; i++)); do
        local setting="${settings[$i]}"
        local value="${values[$i]}"

        if grep -q "^$setting" /etc/ssh/sshd_config; then

            #updating the existing setting
            sudo sed -i "s/^$setting[[:space:]]\+.*/$setting $value/" /etc/ssh/sshd_config
            echo "Setting '$setting' updated to '$value'."
        else

            #adds the setting if it doesnt exist
            echo "$setting $value" | sudo tee -a /etc/ssh/sshd_config > /dev/null
            echo "Added '$setting $value' to /etc/ssh/sshd_config."
        fi
    done
    sleep 2

    #restarts ssh to apply changes
    sudo service ssh restart
    echo "SSH restarted"
    sleep 5
}

SecureShadow(){
    chmod 640 /etc/shadow
    sleep 5
}

RemBadPrograms(){
    local -a Programs=("John The Ripper" "Hydra" "Nginx" "Samba" "Bind9" "Tftpd" "X11vnc/tightvncserver" "Snmp" "Nfs" "Sendmail/postfix" "Xinetd")

    for program in "${Programs[@]}"; do
        #checks if the program is installed
        if command -v "$program"  &> /dev/null; then
            #uninstalls the program
            echo "removing $program..."
            sudo apt-get remove --purge "$program"
            echo "$program removed."
        else
            echo "$program not found"
        fi
    done
    sleep 5
}

configsysctl(){
    local -a new_settings=("net.ipv4.conf.all.accept_redirects = 0" "net.ipv4.ip_forward = 0" "net.ipv4.conf.all.send_redirects = 0" "net.ipv4.conf.default.send_redirects = 0" "net.ipv4.conf.all.rp_filter = 1" "net.ipv4.conf.all.accept_source_route = 0" "net.ipv4.tcp_max_syn_backlog = 2048" "net.ipv4.tcp_synack_retries = 2" "net.ipv4.tcp_syn_retries = 5" "net.ipv4.tcp_syncookies = 1" "net.ipv6.conf.all.disable_ipv6 = 1" "net.ipv6.conf.default.disable_ipv6" "net.ipv6.conf.lo.disable_ipv6")

    for setting in "${new_settings[@]}"; do
        if grep -q "^$setting" /etc/sysctl.conf; then
            echo "Setting '$setting' Already exists"
        else
            echo "$setting" | sudo tee -a /etc/sysctl.conf > /dev/null
            echo "Setting '$setting' added"
        fi
    done
    sleep 5

    sudo sysctl -p
    echo "Settings updated"
    pause 3
}

CheckCronjobs(){
    for cron_dir in /etc/cron.*; do
        if [ -d "$cron_dir" ]; then
            echo "Cronjobs in $cron_dir:"
            cat "$cron_dir" /*
            echo "---------------------------------"
        fi
    done

    if [ -f "/etc/crontab" ]; then
        echo "Cronjobs in /etc/crontab:"
        cat /etc/crontab
        echo "---------------------------------"
    fi

    for user_cron in /var/spool/cron/crontabs/*; do
        user=$(basename "$user_cron")
        echo "Cronjobs for user $user:"
        cat "$user_cron"
        echo "---------------------------------"
    done

    local users=$(cut -f1 -d: /etc/passwd)
    for user in $users; do
        cronjobs=$(sudo crontab -u $user -l 2>/dev/null)
        if [ -n "$cronjobs" ]; then
            echo "Cronjobs for user $user:"
            echo "$cronjobs"
            echo "---------------------------------"
        fi
    done

    pause 60
}


main_menu() {
    clear
    echo "Select an option:"
    echo "1. Update and restart"
    echo "2. Clamtk"
    echo "3. Check for prohibited files"
    echo "4. Configure firewall"
    echo "5. Edit LightDm(ubuntu)"
    echo "6. Edit Lightdm(debian)"
    echo "7. Create missing users"
    echo "8. Add or remove admin access"
    echo "9. Change password for all users"
    echo "10. Change login policy"
    echo "11. Delete unwanted users"
    echo "12. Fix /etc/passwd file"
    echo "13. Restore /etc/passwd/ (only use if points lost)"
    echo "14. Add all admins to sudo and adm groups"
    echo "15. Disable root accounts"
    echo "16. Secure SSH (only do if needed)"
    echo "17. Secure /etc/shadow"
    echo "18. Remove bad programs"
    echo "19. Configure sysctl.conf"
    echo "20. Check all cronjobs"
    echo "21. Exit"
    

    read -p "Enter the number corresponding to your choice: " choice

    case $choice in
        1)
            Update
            ;;
        2)
            Clam
            ;;
        3)
            Chkprohib
            exit
            ;;
        4)  
            Firewall
            ;;

        5)
            LightdmUbuntu
            ;;

        6)
            LightdmDebian
            LightdmDeb2
            ;;

        7)
            CreateMisUsrs
            ;;

        8)
            AddRemoveAdmin
            ;;

        9) 
            Changepass
            ;;
        
        10)
            logindefs
            logindefs2
            ;;

        11)
            Deluser
            ;;

        12)
            Backupetcpass
            Remshbash
            ;;
        
        13)
            Restorepass
            ;;

        14)
            Mangroup
            ;;

        15)
            Disrootacc
            ;;  

        16)
            Edit_sshid_cofig
            ;;  

        17)
            SecureShadow
            ;;

        18)
            RemBadPrograms
            ;;

        19)
            configsysctl
            ;;

        20)
            CheckCronjobs
            ;;    

        21)
            echo "Exiting program."
            exit
            ;;
        *)
            echo "Invalid choice. Please enter a number from the menu."
            ;;
    esac
}

while true; do
    main_menu
done
