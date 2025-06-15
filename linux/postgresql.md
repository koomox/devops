# PostgreSQL         
Home: [Link](https://www.postgresql.org/)                   
### Install PostgreSQL       
Update package list and install prerequisites            
```sh
sudo apt install curl ca-certificates postgresql-common
```
Download the PostgreSQL GPG public key              
```sh
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg
```
Add the official PostgreSQL APT repository            
```sh
echo -e "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] https://apt.postgresql.org/pub/repos/apt $(lsb_release -sc)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list
cat /etc/apt/sources.list.d/postgresql.list
```
Tuna mirror          
```sh
echo -e "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/postgresql/repos/apt/ $(lsb_release -sc)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list
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
Modify the user to use password authentication. Replace `your_password` with a strong password.         
```
postgres=# ALTER USER postgres WITH PASSWORD 'your_password';
```
You can create a new PostgreSQL user and password by executing the following queries:         
```
postgres=# CREATE USER your_userwith CREATE CREATEDB ROLE;
postgres=# ALTER USER your_userwith PASSWORD 'your_password';
```
Exit the database console.          
```
postgres=# \q
```
How we can check which encryption method we are using?         
```
postgres=# show password_encryption;
```
Open the `/etc/postgresql/17/main/postgresql.conf`         
```sh
sudo vim /etc/postgresql/17/main/postgresql.conf
```
In `postgresql.conf`, you should set:         
```
password_encryption = 'scram-sha-256'
```
Open the `/etc/postgresql/17/main/pg_hba.conf` main PostgreSQL configuration file using a text editor like `vim`.        
```sh
sudo vim /etc/postgresql/17/main/pg_hba.conf
```

Replace `peer` with `scram-sha-256` to enable password authentication.        

| TYPE | DATABASE | USER     | ADDRESS       | METHOD        |
| ---- | -------- | -------- | ------------- | ------------- |
| host | all      | postgres | 127.0.0.1/32  | peer          |
| host | all      | all      | ::1/128       | md5           |
| host | all      | hostman  | 0.0.0.0/0     | scram-sha-256 |

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
CREATE ROLE db_admin WITH LOGIN CREATEDB PASSWORD 'MyS3curePassWD!';
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

View All Users (Roles), Using psql shortcut: `\du`, Or with a SQL query:           
```sql
SELECT rolname, rolsuper, rolcreatedb, rolcreaterole, rolcanlogin FROM pg_roles;
```
View All Databases, Using psql shortcut: `\l`, Or with a SQL query:      
```sql
SELECT datname, datdba::regrole, encoding, datcollate, datctype FROM pg_database WHERE datistemplate = false;
```