# PostgreSQL         
Home: [Link](https://www.postgresql.org/)                   
### Install PostgreSQL       
Update package list and install prerequisites            
```sh
sudo apt install curl ca-certificates postgresql-common
```
Download the PostgreSQL GPG public key              
```sh
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
```
Add the official PostgreSQL APT repository            
```sh
echo -e "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -sc)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list
cat /etc/apt/sources.list.d/postgresql.list
```
Update package list and install the latest PostgreSQL version        
```sh
sudo apt update
sudo apt install postgresql
```
```sh
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql
```
### Secure the PostgreSQL Server           
Access the PostgreSQL database console as the user postgres.          
```sh
sudo -u postgres psql
```
Modify the user to use password authentication. Replace `Secur3Passw0rd` with a strong password.         
```
postgres=# ALTER ROLE postgres WITH ENCRYPTED PASSWORD 'Secur3Passw0rd';
```
Exit the database console.          
```
postgres=# \q
```
Open the `/etc/postgresql/16/main/pg_hba.conf` main PostgreSQL configuration file using a text editor like `vim`.        
```sh
sudo vim /etc/postgresql/16/main/pg_hba.conf
```
Find the following configuration directive.           
```
local    all    postgres    peer
```
Edit the last column and change it from `peer` to `scram-sha-256` to enable password authentication for the local postgres user.       
```
local    all    postgres    scram-sha-256
```
Find the following directive for all PostgreSQL users.         
```
local    all    all    peer
```
Replace `peer` with `scram-sha-256` to enable password authentication.           
```
local    all    all    scram-sha-256
```
Restart PostgreSQL to apply the configuration changes.          
```sh
sudo systemctl restart postgresql
```
Access the PostgreSQL console as postgres.        
```sh
psql -U postgres -W
```
Enter the password you set earlier and press :key_enter when prompted.         

Create a new `db_admin` database role and grant `LOGIN` and `CREATEDB` privileges to allow the user to log in to the database server and create databases.           
```
postgres=# CREATE ROLE db_admin WITH LOGIN CREATEDB ENCRYPTED PASSWORD 'MyS3curePassWD!';
```
Access the PostgreSQL database server as `db_admin` and enter the password you created earlier.         
```sh
psql -U db_admin -d postgres -W
```
Create a sample `school` database.          
```
postgres=> CREATE DATABASE school;
```
Switch to the new database.        
```
postgres=> \c school;           
```
Enter `db_admin` role and press `Enter` when prompted.         