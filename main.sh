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
    read -p "Enter a file extention to search for: " ext_user_inpt
    find / -type f -name "*.$ext_user_inpt"
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
            if grep -q "^$settings=" "$config_file"; then
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
}

main_menu() {
    clear
    echo "Select an option:"
    echo "1. Update and restart"
    echo "2. Clamtk"
    echo "3. Check for prohibited files"
    echo "4. Configure firewall"
    echo "5. Edit LightDm(ubuntu)"
    echo "6. Exit"

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
