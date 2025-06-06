# toolz

Welcome to **toolz**!  
This all-in-one Bash utility provides helpful features for system administration, including file search, system information, process management, and user/group management. This guide explains each feature and provides step-by-step usage instructions.

---

## Setup

**Before running the script:**

- First of all, you will need a running linux operation system
- Make sure your script is executable (chmod +x toolz.sh)
- Do **not** run the script in your current shell for best experience. run the script with the following commands: ("bash toolz.sh" or just "./toolz.sh")

---

## Main Menu Functions

### Find Helper (-f)

Search for files/directories by name, type, or size.

- **How to use:**
- Enter the path to search
- Choose search type:
  - `-n`: Name (file or directory)
  - `-f`: File name
  - `-d`: Directory name
  - `-s`: Size (e.g., `+100k` for files larger than 100KB)

---

### System Information (-s)

View system hardware and OS details.

- **Options:**
- `-i`: Device information (hostname, RAM, CPU, OS)
- `-d`: Disk information (disk usage)
- `-m`: Memory information (total/used/free)
- `-p`: Running processes (shows current processes in real-time)

---

### Process Management (-p)

Monitor, sort, find, and kill processes.

- **Options:**
- `-r`: Running processes (shows current running processes)
- `-s`: Sorted processes:
  - `-c`: by CPU
  - `-m`: by RAM
  - `-r`: by Runtime
- `-g`: Get processes:
  - `-i`: by PID
  - `-n`: by Name
- `-k`: Stop process:
  - `-i`: by PID
  - `-n`: by Name

---

### User & Group Management (-u)

Manage users, administrators, and groups.

- **User Management (`-u`):**
- `-a`: Show all users
- `-c`: Create a new user
- `-f`: Find a specific user
- `-u`: Update your password
- `-r`: Remove a user

- **Administrators Management (`-a`):**
- `-a`: Show all administrators
- `-s`: Set a user as administrator
- `-r`: Remove a user from administrators

- **Group Management (`-g`):**
- `-a`: Show all groups
- `-f`: Find a specific group
- `-c`: Create a new group
- `-r`: Remove a group

---

## Additional Notes

- **Sudo required:** Some actions (creating/removing users/groups, changing passwords) require sudo privileges.
- **Password rules:** When creating/updating a user, passwords must be at least 8 characters, with at least 2 letters and numbers.

---

## Troubleshooting

- **Permission denied:** Run the script with a user that has sudo privileges.
- **Invalid options:** Enter options exactly as shown (e.g., `-f`, not `f`).

---

**Happy administrating with toolz!**



