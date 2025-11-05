### backup.sh
* Created to speed up deployment time
* Stem from having to ssh into multiple servers to backup directory which eats into deployment time
* Reusable script as the number of servers and path is user defined
* Criteria to ensure all naming convention of servers are prefixed

### cleanup_logs.sh
* Created for clean up to prevent running out of memory
* To be run with cron jobs
* Default days will be 7 days unless user specified

## cert_mgmt
### generate_csr.sh
* Created for generating private keys and CSRs
* Reduces the need to remember the full parameter of OpenSSL and algos avail
* CSRs are generated into directory /opt/ssl/csr

### sign_csr.sh
* Created for signing CSRs using available CA certificates
* CA certificates should be stored inside /opt/ssl/ca
* Only list down the CAs available inside the directory
* Key must have same name as cert