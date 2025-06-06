#!/bin/bash

GREEN="\033[32m"
RESET="\033[0m"


#Main toolz program
function toolz() {
	getUserInput

	#Checking user input
	case "$userInput" in
	-f)
	findHelper ;;
	-s)
	systemInfo ;;
	-p)
	processManage ;;
	-u)
	userManage ;;
	-h)
	helper ;;
	*)
	echo "Invalid option.. Exiting" ;;
	esac
}






#getting user input
function getUserInput() {
	printf "%b\n" "-f)${GREEN} Find Helper${RESET}"
	printf "%b\n" "-s)${GREEN} System Information${RESET}"
	printf "%b\n" "-p)${GREEN} Process Management${RESET}"
	printf "%b\n" "-u)${GREEN} User & Groups Management${RESET}"
	printf "%b\n" "-h)${GREEN} Help${RESET}"
	read -p "Choose an option: " userInput
}


#Find helper function
function findHelper() {
	read -p "Path: " userFindPath
	#checks if path exists
	if [[ -e $userFindPath ]]; then
		printf "%b\n" "-n)${GREEN} Name${RESET}"
		printf "%b\n" "-f)${GREEN} File${RESET}"
		printf "%b\n" "-d)${GREEN} Directory${RESET}"
		printf "%b\n" "-s)${GREEN} Size${RESET}"
		read -p "Choose an option: " userFindOpt 

		
		case "$userFindOpt" in
		-n)
		read -p "Name of file/dir: " userOptName
		find $userFindPath -name $userOptName 2> /dev/null 
		;;
		-f)
		read -p "Name of file: " userFileName
		find $userFindPath -type f -name $userFileName 2> /dev/null
		;;
		-d)
		read -p "Name of dir: " userDirName
		find $userFindPath -type d -name $userDirName 2> /dev/null
		;;
		-s)
		echo "[Number][+=larger then, -=smaller then, c=bytes, k=KB, M=MB, G=GB] ex: +1000k"
		read -p "Size of file/dir: " userFileSize 2> /dev/null
		find $userFindPath -size $userFileSize 2> /dev/null
		;;
		*)
		echo "Invalid option.. Exiting" 
		exit ;;
		esac
		
	#if user's path doesnt exists
	else
		printf "Did not found path %s\n" $userFindPath
	fi

}


#System information function
function systemInfo() {
	printf "%b\n" "-i) ${GREEN} Device Information${RESET}"
	printf "%b\n" "-d) ${GREEN} Disk Information${RESET}"
	printf "%b\n" "-m) ${GREEN} Memory Information${RESET}"
	printf "%b\n" "-p) ${GREEN} Running Processes${RESET}"
	read -p "Choose an option: " userSysOpt
	
	#checking $user input
	case $userSysOpt in
	-i) #Device information 
	#Getting device name
	printf "%b" "Device Name: ${GREEN}$HOSTNAME${RESET}\n" 
	#Getting storage size
	df -h | awk -v GREEN="$GREEN" -v RESET="$RESET" '/\/dev\/sda/ {printf "Storage: %s%s%s\n", GREEN, $2, RESET}'
	#Getting device RAM
        free --mega | awk -v GREEN="$GREEN" -v RESET="$RESET" '/^Mem:/ {printf "RAM: %s%dMB%s\n", GREEN, $2, RESET}'
	#Getting device CPU
	awk -v GREEN="$GREEN" -v RESET="$RESET" -F': ' '/model name/ {printf "CPU: %s%s%s\n", GREEN, $2, RESET; exit}' /proc/cpuinfo
	#Getting OS and architecture
	cat /etc/os-release | awk -F'=' '/PRETTY_NAME/ {print $2}' | awk -v GREEN="$GREEN" -v RESET="$RESET" -F'"' '{printf "OS: %s%s%s", GREEN, $2, RESET}'; printf "%b\n" "${GREEN}$(uname -m)${RESET}" 
	;;
	-d) #Disk information
 	df -h | awk -v GREEN="$GREEN" -v RESET="$RESET" '/\/dev\/sda/ {printf "Size Used Avail\n%s%s %s %s%s", GREEN, $2, $3, $4, RESET}' | column -t 
;;
	-m) #Memory Information
	free --mega | awk -v GREEN="$GREEN" -v RESET="$RESET" '/Mem:/ {printf "Total Used Free\n%s%sM %sM %sM%s", GREEN, $2, $3, $3, RESET}' | column -t 
	;;
	-p) $Running Processes
	top 
	;;
	*)
	echo "Invalid option.. Exiting" 
	exit ;;
	esac
}


#Process management function
function processManage() {
	printf "%b\n" "-r) ${GREEN}Running Processes${RESET}"
	printf "%b\n" "-s) ${GREEN}Sorted Processes${RESET}"
	printf "%b\n" "-g) ${GREEN}Get Processes${RESET}"
	printf "%b\n" "-k) ${GREEN}Stop Process${RESET}"
	read -p "Choose an option: " userProcessOpt

	case $userProcessOpt in
	-r) #Running processes 
	top
	;;
	-s) #Sory Processes by CPU RAM or Runtime 
	printf "Sort Processes by:\n"
	printf "%b\n" "-c) ${GREEN}CPU${RESET}"
	printf "%b\n" "-m) ${GREEN}RAM${RESET}"
	printf "%b\n" "-r) ${GREEN}Runtime${RESET}"
	read -p "Choose an option: " userSortOpt

	case $userSortOpt in
	-c) #Sorted processes by CPU
	ps aux --sort=+%cpu ;;
	-m) #Sorted Processes by RAM
	ps aux --sort=+%mem ;;
	-r) #Sorted Processes by Runtime
	ps aux --sort=etime ;;
	esac ;;
	-g) #Getting process by id or name
	printf "%b\n" "-i) ${GREEN}PID${RESET}"
	printf "%b\n" "-n) ${GREEN}Process Name${RESET}"
	read -p "Choose an option: " userGetProcOpt

	case $userGetProcOpt in
	-i) #Getting process by id
	read -p "PID: " userPidOpt 
	ps -p $userPidOpt &> /dev/null
	if [[ $? == 0 ]]; then
		ps -p $userPidOpt -o comm=
	else
		printf "Process with %s PID was not found\n" "$userPidOpt"
	fi
	;;
	-n) #Getting process by name
	read -p "Process Name: " userProcNameOpt
	pgrep -x $userProcNameOpt &> /dev/null 
	if [[ $? == 0 ]]; then
		ps aux | grep $userProcNameOpt
	else
		printf "Process %s was not found\n" "$userProcNameOpt"
	fi 
		
	esac ;;
	
	-k) #killing process by name or pid
	printf "%b\n" "-i)${GREEN} PID${RESET}"
	printf "%b\n" "-n)${GREEN} Process Name${RESET}"
	read -p "Choose an option: " userKillProcOpt

	case $userKillProcOpt in

	-i)
	read -p "PID: " userPidOpt
	if kill -0 $userPidOpt &> /dev/null; then
		while true; do
			read -p "Are you sure you went to kill this process? (y/n) " userPidChoice 	
			case $userPidChoice in
			y|Y) #killing process
			kill -9 $userPidOpt
			break ;;
			n|N) 
			echo "Exiting.." 
			break ;;
			esac
		done 
	else
		printf "Process with id %s was not found\n" $userPidOpt	
	fi
	;;	
	-n) #killing process by name
	read -p "Process Name: " userPnameOpt
	pgrep $userPnameOpt &> /dev/null
	if [[ $? == 0 ]]; then
		while true; do
			read -p "Are you sure you want to kill this process? (y/n) " userPnameChoice

		        case $userPnameChoice in
	          	y|Y) #killing process by name
	        	pkill -9 $userPnameOpt
			break ;;
	        	n|N) 
			echo "Exiting.."
			break ;;
			esac
		done

	else
		printf "Process %s was not found\n" $userPnameOpt	
	fi
	;;
	*)
	echo "Invalid option.. Exiting" 
	exit ;;

	esac 



	esac #first esac




}




# User management function
function userManage() {

	printf "%b\n" "-u) ${GREEN}Users${RESET}"
	printf "%b\n" "-a) ${GREEN}Administrators${RESET}"
	printf "%b\n" "-g) ${GREEN}Groups${RESET}"
	read -p "Choose an option: " userManageOpt

	case "$userManageOpt" in
		-u) # User management
		printf "%b\n" "-a) ${GREEN}All users${RESET}"	
		printf "%b\n" "-c) ${GREEN}Create a user${RESET}"	
		printf "%b\n" "-f) ${GREEN}Find a user${RESET}"	
		printf "%b\n" "-u) ${GREEN}Update password${RESET}"	
		printf "%b\n" "-r) ${GREEN}Remove user${RESET}"	
		
		read -p "Choose an option: " userManagementOpt

		case "$userManagementOpt" in
			-a) #getting all users
			printf "All Users:\n"
			cat /etc/passwd | awk -v GREEN="${GREEN}" -v RESET="${RESET}" -F':' '/\/home\/*/ {printf "%s%s%s\n", GREEN, $1, RESET}'
			;;
			-c) #creating a user
			read -p "Username: " newUsername; 
			# Check if passowrd length is at leat 8 and contains at least 2 letters and numbers
		if [[ $? == 0 ]]; then
			while true; do	
			read -s -p "Password: " newUserPassword; echo	

			if [[ "${#newUserPassword}" -gt 7 ]] && [[ ${newUserPassword} =~ ([a-zA-Z].*){2,} ]] && [[ ${newUserPassword} =~ ([0-9].*){2,} ]]; then

				#check if passwords match
				read -s -p "Re-enter password: " newUserVerifyPassword; echo 
				if [[ ${newUserPassword} == ${newUserVerifyPassword} ]]; then

					sudo useradd -m -s /bin/bash ${newUsername} &> /dev/null
					echo "$newUsername:$newUserPassword" |sudo chpasswd
					if [[ $? == 0 ]]; then	
						printf "%b\n" "${newUsername} was ${GREEN}successfully${RESET} created" 
						break;
					else
						echo "Something went wrong"
						break;
					fi
				else
					printf "Passwords don't match.. Exiting\n"
					exit 1
				fi
			else
				printf "Password must be at least 8 characters long and include at least 2 letters
and 2 numbers\n"


			fi

			done
		fi
			;;
			-f) #find a specific user and give his info
			read -p "Username: " findUser
			#checks if user put an input
			if [[ -z $findUser ]]; then
				echo "Invalid option.. Exiting"
				exit 1
			fi
			#checks if user exists	
			if ! id $findUser &> /dev/null; then
				echo "User does not exist"
				exit 2
			fi
			
			#getting user id
			userId=$(id -u $findUser)

			#getting user groups
			userGroups=$(id -Gn $findUser | sed 's/ / : /g')

			#getting account creation date
			shadowUser=$(sudo grep "^$findUser:" /etc/shadow)	
			if [[ -n $shadowUser ]]; then
				dateInDays=$(echo "$shadowUser" | cut -d: -f3)
	
				if [[ -n $dateInDays ]]; then
					creationDate=$(date -d "1970-01-01 +$dateInDays days" "+%d-%m-%Y")
				else
					creationDate="N/A"	

				fi
			else
				creationDate="N/A"

			fi


			#getting last login time
			userLastLogin=$(last -F $findUser | head -n 1 | awk -v GREEN="$GREEN" -v RESET="$RESET" ' {printf "%s%s-%s-%s-%s-%s%s", GREEN, $4, $5, $6, $7, $8, RESET}')


			#printing all the values
			printf "%b\n" "Username: ${GREEN}${findUser}${RESET}"
			printf "%b\n" "UID: ${GREEN}${userId}${RESET}"
			printf "%b\n" "Groups: ${GREEN}${userGroups}${RESET}"
			printf "%b\n" "Created: ${GREEN}${creationDate}${RESET}"
			printf "%b\n" "Last Login: ${GREEN}${userLastLogin}${RESET}"
			;;		
				
			-u) #update existing user password
			read -p "Username: " userUpdPass
			
			#check if user exist
			if ! id "$userUpdPass" &> /dev/null; then
				echo "User ${userUpdPass} does not exist"
				exit 1 
			fi
			
			while true; do
				read -s -p "New Password: " userNewPassword; echo
				if [[ ${#userNewPassword} -gt 7 ]] && [[ ${userNewPassword} =~ ([a-zA-Z].*){2,} ]] && [[ ${userNewPassword} =~ ([0-9].*){2,} ]]; then
					read -s -p "Re-enter password: " verifyNewPassword; echo 
					if [[ ${userNewPassword} == ${verifyNewPassword} ]]; then

						echo "${userUpdPass}:${userNewPassword}" | sudo chpasswd  &> /dev/null
						if [[ $? -eq 0 ]]; then

							printf "%b\n" "Password has been ${GREEN}successfully${RESET} changed"
							break;
						
						else
							printf "Something went wrong\n"
							exit 	
						fi
					else
						echo "Passwords don't match.. Exiting"
						exit
					fi
				else
				printf "Password must be at least 8 characters long and include at least 2 letters\n"
				fi
			done
			;;

			-r) #remove user
			read -p "Username: " removeUser

			#check if user exists
			if ! id $removeUser &> /dev/null; then
				printf "${removeUser} was not found.. Exiting\n"
				exit 1	
	
			fi
			#if user exist ask if sure
			while true; do
			read -p "Are you sure you want to remove ${removeUser}? (y/n) " userRemoveChoice

			case "$userRemoveChoice" in
			[yY])
			sudo userdel -r $removeUser 
			printf "${removeUser} was ${GREEN}successfully${RESET} deleted\n"
			break ;;
			[nN])
			echo "canceling.."
			break ;;
			esac
			done 
			;;

		esac ;;
	-a) #Administrators management

	printf "%b\n" "-a) ${GREEN}All administrators${RESET}"
	printf "%b\n" "-s) ${GREEN}Set administrators${RESET}"
	printf "%b\n" "-r) ${GREEN}Remove administrators${RESET}"

	read -p "Choose an option: " userAdminOpt

	case $userAdminOpt in

	-a) #Get all the admins (users in sudo group)
	printf "All Administrators:\n"
	getent group sudo | awk -F':' -v G="${GREEN}" -v R="${RESET}" ' {printf "%s%s%s\n", G, $4, R}' | tr ',' '\n'
	;;
	-s) # Set a user as admin
	read -p "Username: " setUserAdmin
	if ! id $setUserAdmin &> /dev/null; then
		printf "Didn't found user %s\n" $setUserAdmin	
		exit 1
	fi 	

	# Check if user already in sudo group
	if getent group sudo | grep ${setUserAdmin} &> /dev/null; then
		printf "${setUserAdmin} is ${GREEN}already${RESET} an administrator\n"
		exit 0
	fi

	sudo usermod -aG sudo $setUserAdmin &> /dev/null
	if [[ $? -eq 0 ]]; then
		printf "%b\n" "Added ${setUserAdmin} to the ${GREEN}sudo group${RESET}"
		exit 1
	else
		printf "Something went wrong\n"
		exit 2

	fi
	;;
	
	-r) #Remove a user from sudo group
	read -p "Username: " removeUserAdmin	

	#check if user exist
	if ! id $removeUserAdmin &> /dev/null; then
		printf "Didn't found user ${removeUserAdmin}\n"
		exit 1
	fi

	#check if user is an admin
	if ! getent group sudo | grep $removeUserAdmin &> /dev/null; then
		printf "${removeUserAdmin} is ${GREEN}already${RESET} not an administrator\n"
		exit 0
	fi

	# if user exist and is not an admin
	sudo gpasswd --delete $removeUserAdmin sudo &> /dev/null
	if [[ $? -eq 0 ]]; then
		printf "Removed ${removeUserAdmin} ${GREEN}successfully${RESET} from the sudo group\n"
	exit 0
	fi	
	;;

	*)
	echo "Invalid option.. Exiting"
	exit ;;
	esac ;;


	-g) # Group management
	printf "%b\n" "-a) ${GREEN}All groups${RESET}"
	printf "%b\n" "-f) ${GREEN}Find group${RESET}"
	printf "%b\n" "-c) ${GREEN}Create group${RESET}"
	printf "%b\n" "-r) ${GREEN}Remove group${RESET}"
	read -p "Choose an option: " userGroupOpt

	case $userGroupOpt in
	-a) #Getting all groups
	getent group | awk -F':' -v G="${GREEN}" -v R="${RESET}" '{members = ($4 == "") ? "N/A" : $4; printf "Group: %s%s%s\nGID: %s%s%s\nMembers: %s%s%s\n\n", G, $1, R, G, $3, R, G, members, R}' 
	;;

	-f) # Find specific group
	while true; do
		read -p "Group: " userFindGroup

		if grep -q $userFindGroup /etc/group; then
			getent group | awk -v u="$userFindGroup" '$1 ~ "^" u' | awk -F':' -v G="${GREEN}" -v R="${RESET}" '{ members = ($4 == "") ? "N/A" : $4; printf "Group: %s%s%s\nGID: %s%s%s\nMembers: %s%s%s\n", G, $1, R, G, $3, R, G, members, R}' 	
			break; 
		fi	

	done	
	;;

	-c) # Creating a new group
	while true; do
		read -p "Group name (e - exit): " newGroupName
		if [[ $newGroupName == "e" ]]; then
			exit 0
		fi
		sudo groupadd ${newGroupName} &> /dev/null
		groupAddExitStatus=$?

		if [[ ${groupAddExitStatus} -eq 0 ]]; then
			printf "Group ${newGroupName} was ${GREEN}successfully${RESET} created\n"	
		break;	
		elif [[ ${groupAddExitStatus} -eq 9 ]]; then
			printf "Group ${newGroupName} already exist\n"
		else
			printf "Something went wrong\n"
		fi
	done	
	;;

	-r) # Remove a group 
	while true; do
		read -p "Group name (e -exit): " removeGroup
		
		if [[ ${removeGroup} == "e" ]]; then
			exit 0 
		fi

		if grep -w -q ${removeGroup} /etc/group; then
			read -p "Are you sure? (y/n): " removeGroupChoice

			case ${removeGroupChoice} in
			[yY])
			sudo groupdel $removeGroup &> /dev/null
			if [[ $? -eq 0 ]]; then
				printf "Group ${removeGroup} was ${GREEN}sucssesfully${RESET} removed\n"
				exit 0
			else
				printf "Something went wrong\n"
			fi
			;;
			[nN])
			printf "Cancelling.."
			exit 0 ;;
			*)
			printf "Invalid input.. exiting\n"
			exit 1 ;;	
			esac
		else
			printf "Group ${removeGroup} was not found\n"
			exit 2 
		fi 	

	done
	;;

	esac
	;;

	*)
	echo "Invalid option.. Exiting"
	exit ;;

	esac #user management main case


}





# Helper function
function helper() {
	# Welcome
	printf "Welcome to ${GREEN}toolz${RESET}! This all-in-one Bash utility provides helpful features for system administration, including file search, system information, process management, and user/group management. This guide explains each feature and provides step-by-step usage instructions.\n\n" 
	

	# Setting up the script:
	printf "*** ${GREEN}BEFORE RUNNING SCRIPT${RESET} ***\n"
	echo -e "\t- Make sure you script is executable (chmod +x toolz.sh)" 
	echo -e "\t- Do not run the script on your current shell or it will not run well"
	echo -e "\t- Use (bash toolz.sh) or (just ./toolz.sh) to run the script\n"	

	# Main menu functions:
	printf "*** ${GREEN}MAIN MENU FUNCTIONS${RESET} ***\n"
	printf "\t*** ${GREEN}Find Helper (-f)${RESET} ***\n"

	echo -e "\t\tSearch for files/directories by name,type or size"
	echo -e "\t\tEnter the path to search\n\t\tChoose search type:\n\t\t-n: Name (file or directory)\n\t\t-f: File name\n\t\t-d: Directory name\n\t\t-s: Size (e.g +100k for files larter then 100KB)\n" 


	printf "\t*** ${GREEN}System Information (-s)${RESET} ***\n"
	echo -e "\t\tView system hardware and OS details"
	echo -e "\t\tOptions:\n\t\t-i) Device information (hostname, RAM, CPU, OS)\n\t\t-d) Disk information (disk usage)\n\t\t-m) Memory information (total/used/free)\n\t\t-p) Running processes (shows current processes in real-time)\n"


	printf "\t*** ${GREEN}Process Management (-p)${RESET} ***\n"
	echo -e "\t\tMonitor, sort, find, and kill processes"
	echo -e "\t\tOptions:\n\t\t-r) Running processes (another place to output the current running processes)\n\t\t-s) Sorted processes:\n\t\t\t-c) by CPU\n\t\t\t-m) by RAM\n\t\t\t-r) by Runtime\n"
		
	echo -e "\t\t-g) Get processes:\n\t\t\t-i) by PID\n\t\t\t-n) by Name"
	echo -e "\t\t-k) Stop process:\n\t\t\t-i) by PID\n\t\t\t-n) by Name\n"


	printf "\t*** ${GREEN}User & Group Management (-u)${RESET} ***\n"
	echo -e "\tManage users, administrators, and groups"
	echo -e "\t\tOptions:\n\t\t-u) User Management:\n\t\t\t-a) Show all users\n\t\t\t-c) Creates a new user\n\t\t\t-f) Find a specific user\n\t\t\t-u) Update your'e password\n\t\t\t-r) Remove a user\n"

	echo -e "\t\t-a) Administrators Management:\n\t\t\t-a) Show all administrators\n\t\t\t-s) Set a user as admininstrator\n\t\t\t-r) Remove a user from administrators\n"
	
	echo -e "\t\t-g) Group Management:\n\t\t\t-a) Show all the groups\n\t\t\t-f) Find a specific group\n\t\t\t-c) Create a new group\n\t\t\t-r) Remove a group\n"

	# Additional notes:
	printf "*** ${GREEN}ADDITIONAL NOTES${RESET} ***\n"
	echo -e "\t* Sudo required: Some actions (creting/removing users/groups. changing passwords) require sudo privileges.\n\t* Password rules: When creating/updating a user, passwords must be at least 8 characters, with at least 2 letters and numbers.\n"

	# Troubleshooting
	printf "*** ${GREEN}TROUBLESHOOTING${RESET} ***\n"
	echo -e "\t* Permission denied: Run the script with a user that has sudo privileges.\n\t* Invalid options: Enter options exactly as shows (e.g -f, not f).\n"

}

toolz #invoking the script 
