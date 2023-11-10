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


chkprohib() {
    read -p "Enter a file extention to search for: " ext_user_inpt
    find / -type f -name "*.$ext_user_inpt"
}

main_menu() {
    clear
    echo "Select an option:"
    echo "1. Update and restart"
    echo "2. clamtk"
    echo "3. Auto-update(consider GUI)"
    echo "4. Exit"

    read -p "Enter the number corresponding to your choice: " choice

    case $choice in
        1)
            Update
            ;;
        2)
            Clam
            ;;
        3)
            chkprohib
            exit
            ;;
        4)
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
