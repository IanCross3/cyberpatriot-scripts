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

Clamtk() {
    echo "Installing Clamtk and running scan"
    sudo apt-get -y install clamtk
    sudo freshclam

}


placeholder1() {
    echo "placeholder"
}

main_menu() {
    clear
    echo "Select an option:"
    echo "1. Update and restart"
    echo "2. Another Task"
    echo "3. Different Task"
    echo "4. Exit"

    read -p "Enter the number corresponding to your choice: " choice

    case $choice in
        1)
            Update
            ;;
        2)
            Clamtk
            ;;
        3)
            placeholder1
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
