# MySQL Backup and Zabbix Alert Script

This script is designed to take a backup of a MySQL database and send an alert to a Zabbix server if the backup process fails. The backup is created using the `mysqldump` command and then compressed using `gzip`. The compressed backup file is then uploaded to an FTP server using `lftp`. If any step fails during the backup process, an alert is sent to the Zabbix server using the `zabbix_sender` command.

## Prerequisites

- MySQL server with a valid user and password.
- Zabbix server details (ZABBIX, PORT, KEY, HOST, TLS_IDENTION, PSKFILE).
- Directory (`DIR`) to store the backup files.
- FTP server details (FTP_HOST, FTP_USER, FTP_PASS).
- Zabbix sender and lftp should be installed on the system.

## Usage

1. Open a terminal and navigate to the directory where the script file is located.
2. Make the script file executable using the following command:
   ```
   chmod +x script.sh
   ```
3. Modify the script variables according to your environment. The variables that need to be configured are:
   - `ZABBIX`: Zabbix server IP or hostname.
   - `PORT`: Zabbix server port.
   - `KEY`: Zabbix item key for sending alerts.
   - `HOST`: Zabbix host name.
   - `TLS_IDENTION`: TLS identity for Zabbix server connection.
   - `PSKFILE`: Path to the TLS PSK file.
   - `MYSQL_USER`: MySQL user name.
   - `MYSQL_PASS`: MySQL password.
   - `DATE`: Date format for the backup file.
   - `DIR`: Directory to store the backup files.
   - `RETENTION`: Date format for the backup file to be removed.
   - `FTP_HOST`: FTP server IP or hostname.
   - `FTP_USER`: FTP user name.
   - `FTP_PASS`: FTP password.
4. Save the changes to the script file.
5. Run the script using the following command:
   ```
   ./script.sh
   ```

## Script Flow

1. The script starts by defining the necessary variables.
2. It runs the `mysqldump` command to create a backup of all databases, providing the MySQL user and password.
3. If the backup process is successful, it moves to the backup directory and compresses the backup file using `gzip`.
4. If the compression is successful, it uses `lftp` to connect to the FTP server and upload the compressed backup file.
5. If the upload is successful, it removes the backup files older than the retention date.
6. If any step fails during the backup process, an error message is assigned to the `MSG` variable, and an alert is sent to the Zabbix server using `zabbix_sender`.
7. The script exits with a status code of 0 if the backup process is successful. Otherwise, it exits with a status code of 1.

Note: Make sure to properly configure the Zabbix server details and the necessary dependencies before running the script.
