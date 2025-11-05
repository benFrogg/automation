### backup.sh
* Created to speed up deployment time
* Stem from having to ssh into multiple servers to backup directory which eats into deployment time
* Reusable script as the number of servers and path is user defined
* Criteria to ensure all naming convention of servers are prefixed

### cleanup_logs.sh
* Created for clean up to prevent running out of memory
* To be run with cron jobs
* Default days will be 7 days unless user specified