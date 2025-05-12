# Dynamic Hosts Updater

A Bash script to automatically update the `/etc/hosts` file with dynamic IP addresses for multiple hostnames specified in a configuration file. This is useful for environments where hostnames (e.g., AWS Elastic Load Balancers) have dynamic IPs and direct DNS configuration is restricted.
# Dynamic Hosts Updater

A Bash script to automatically update the `/etc/hosts` file with dynamic IP addresses for multiple hostnames specified in a configuration file. This is useful for environments where hostnames (e.g., AWS Elastic Load Balancers) have dynamic IPs and direct DNS configuration is restricted.

## Features
- Reads hostnames from a configuration file (`/etc/hosts_list.txt`).
- Resolves hostnames to IPs using a public DNS server (Google's `8.8.8.8`), handling CNAME records.
- Updates `/etc/hosts` only for changed IPs, preserving other entries.
- Logs actions and errors to `/var/log/update_etc_host.log`.
- Runs automatically every 30 minutes via a cron job.

## System Requirements
- **Operating System**: Linux distributions (e.g., Ubuntu 18.04+, Debian 10+, CentOS 7+, or similar).
- **Dependencies**:
  - Bash (preinstalled on most Linux systems).
  - `dig` (part of the `dnsutils` package on Debian/Ubuntu or `bind-utils` on CentOS/RHEL).
- **Permissions**: Root access to modify `/etc/hosts` and set up cron jobs.
- **Network**: Outbound access to DNS server `8.8.8.8` on port 53 (UDP/TCP). If blocked, consider the SSH-based alternative (not included in this version).
- **Storage**: Minimal disk space for the script, configuration file, and logs.

**Note**: This script is not compatible with non-Linux systems (e.g., Windows, macOS) due to its reliance on `/etc/hosts` and Linux-specific commands. For other systems, modifications would be needed (e.g., using `C:\Windows\System32\drivers\etc\hosts` on Windows).

## Installation

1. **Install Dependencies**:
   - On Debian/Ubuntu:
     ```bash
     sudo apt-get update
     sudo apt-get install dnsutils
     ```
   - On CentOS/RHEL:
     ```bash
     sudo yum install bind-utils
     ```

2. **Create the Configuration File**:
   - Create `/etc/hosts_list.txt`:
     ```bash
     sudo nano /etc/hosts_list.txt
     ```
   - Add hostnames, one per line. Example:
     ```
     unreachable.host.com
     # Add more hostnames here
     # anotherhost.vectordev.com.mx
     ```
   - Set permissions:
     ```bash
     sudo chmod 644 /etc/hosts_list.txt
     ```

3. **Install the Script**:
   - Create the script file:
     ```bash
     sudo nano /usr/local/bin/update-etc-host.sh
     ```
   - Copy and paste the contents of `update-etc-host.sh` from this repository.
   - Save and close.
   - Make it executable:
     ```bash
     sudo chmod +x /usr/local/bin/update-etc-host.sh
     ```

4. **Test the Script**:
   - Run manually:
     ```bash
     sudo /usr/local/bin/update-etc-host.sh
     ```
   - Check `/etc/hosts` for updated IPs:
     ```bash
     cat /etc/hosts
     ```
   - Verify logs:
     ```bash
     cat /var/log/update_etc_host.log
     ```

5. **Set Up a Cron Job**:
   - Open the cron editor:
     ```bash
     sudo crontab -e
     ```
   - Add the following line to run every 30 minutes:
     ```bash
     */30 * * * * /usr/local/bin/update-etc-host.sh
     ```
   - Verify:
     ```bash
     crontab -l
     ```

## Usage
- Add or remove hostnames in `/etc/hosts_list.txt` as needed. The script will process them automatically.
- Monitor logs for errors or updates:
  ```bash
  cat /var/log/update_etc_host.log
  ```
- Test connectivity to updated hostnames:
  ```bash
  telnet unreachable.host.com 443
  ```
  or
  ```bash
  nc -v unreachable.host.com 443
  ```

## Troubleshooting
- **"Could not resolve IP" in logs**: The server cannot reach `8.8.8.8`. Check network restrictions or use an SSH-based alternative.
- **No updates in `/etc/hosts`**: Ensure the script has root permissions and `/etc/hosts_list.txt` exists.
- **CNAME issues**: The script handles CNAMEs (e.g., AWS ELB hostnames) by resolving to the final IP. If it fails, verify `dig` output:
  ```bash
  dig @8.8.8.8 unreachable.host.com
  ```
- Contact your network administrator if DNS queries are blocked.

## License
MIT License. See [LICENSE](LICENSE) for details.

## Contributing
Feel free to open issues or submit pull requests to improve the script or add features (e.g., SSH-based resolution, alternative DNS servers).
## Features
- Reads hostnames from a configuration file (`/etc/hosts_list.txt`).
- Resolves hostnames to IPs using a public DNS server (Google's `8.8.8.8`), handling CNAME records.
- Updates `/etc/hosts` only for changed IPs, preserving other entries.
- Logs actions and errors to `/var/log/update_etc_host.log`.
- Runs automatically every 30 minutes via a cron job.

## System Requirements
- **Operating System**: Linux distributions (e.g., Ubuntu 18.04+, Debian 10+, CentOS 7+, or similar).
- **Dependencies**:
  - Bash (preinstalled on most Linux systems).
  - `dig` (part of the `dnsutils` package on Debian/Ubuntu or `bind-utils` on CentOS/RHEL).
- **Permissions**: Root access to modify `/etc/hosts` and set up cron jobs.
- **Network**: Outbound access to DNS server `8.8.8.8` on port 53 (UDP/TCP). If blocked, consider the SSH-based alternative (not included in this version).
- **Storage**: Minimal disk space for the script, configuration file, and logs.

**Note**: This script is not compatible with non-Linux systems (e.g., Windows, macOS) due to its reliance on `/etc/hosts` and Linux-specific commands. For other systems, modifications would be needed (e.g., using `C:\Windows\System32\drivers\etc\hosts` on Windows).

## Installation

1. **Install Dependencies**:
   - On Debian/Ubuntu:
     ```bash
     sudo apt-get update
     sudo apt-get install dnsutils
     ```
   - On CentOS/RHEL:
     ```bash
     sudo yum install bind-utils
     ```

2. **Create the Configuration File**:
   - Create `/etc/hosts_list.txt`:
     ```bash
     sudo nano /etc/hosts_list.txt
     ```
   - Add hostnames, one per line. Example:
     ```
     unreachable.host.com
     # Add more hostnames here
     # anotherhost.vectordev.com.mx
     ```
   - Set permissions:
     ```bash
     sudo chmod 644 /etc/hosts_list.txt
     ```

3. **Install the Script**:
   - Create the script file:
     ```bash
     sudo nano /usr/local/bin/update-etc-host.sh
     ```
   - Copy and paste the contents of `update-etc-host.sh` from this repository.
   - Save and close.
   - Make it executable:
     ```bash
     sudo chmod +x /usr/local/bin/update-etc-host.sh
     ```

4. **Test the Script**:
   - Run manually:
     ```bash
     sudo /usr/local/bin/update-etc-host.sh
     ```
   - Check `/etc/hosts` for updated IPs:
     ```bash
     cat /etc/hosts
     ```
   - Verify logs:
     ```bash
     cat /var/log/update_etc_host.log
     ```

5. **Set Up a Cron Job**:
   - Open the cron editor:
     ```bash
     sudo crontab -e
     ```
   - Add the following line to run every 30 minutes:
     ```bash
     */30 * * * * /usr/local/bin/update-etc-host.sh
     ```
   - Verify:
     ```bash
     crontab -l
     ```

## Usage
- Add or remove hostnames in `/etc/hosts_list.txt` as needed. The script will process them automatically.
- Monitor logs for errors or updates:
  ```bash
  cat /var/log/update_etc_host.log
  ```
- Test connectivity to updated hostnames:
  ```bash
  telnet unreachable.host.com 443
  ```
  or
  ```bash
  nc -v unreachable.host.com 443
  ```

## Troubleshooting
- **"Could not resolve IP" in logs**: The server cannot reach `8.8.8.8`. Check network restrictions or use an SSH-based alternative.
- **No updates in `/etc/hosts`**: Ensure the script has root permissions and `/etc/hosts_list.txt` exists.
- **CNAME issues**: The script handles CNAMEs (e.g., AWS ELB hostnames) by resolving to the final IP. If it fails, verify `dig` output:
  ```bash
  dig @8.8.8.8 unreachable.host.com
  ```
- Contact your network administrator if DNS queries are blocked.

## License
MIT License. See [LICENSE](LICENSE) for details.

## Contributing
Feel free to open issues or submit pull requests to improve the script or add features (e.g., SSH-based resolution, alternative DNS servers).
