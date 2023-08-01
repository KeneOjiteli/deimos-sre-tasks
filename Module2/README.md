# Containerizing a PHP Application linked to a MYSQL database using Apache as a Web Server.

## Task.
- Using a Web server, Dockerize a PHP application that is linked to a mysql database, Application should be accessible on your localhost and form should be able to write to database using containers and relevant networking,

Additionally,
- Use docker-compose to create the application and database backend and let data persist on container restart.

## Aim and Learning Outcomes.
The aim of this project is to containerize a php application running on Apache and connect to a mysql database. Learning outcomes include knowledge of docker containers, images, volumes, networks and web servers.

## Important Terms to note.
- `Docker` - an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly.
- `Containers` - runnable instance of an image.
- `Docker Volumes` - used to persist data outside the container so it can be backed up or shared, the volumes are stored in `/var/lib/docker/volumes`.
- `Docker Images` - are blueprints of our application that form the basis of containers.
- `Docker Network` - allows you to create a Network of Docker Containers managed by a master node called the manager.
- `Dockerfile` - a text file that contains instructions to build an image.
- `Docker Compose` - a tool used to setup multi-containers.
- `Web server` - a computer program that accepts and responds to requests from clients eg Apache.
- `Apache` - a free and open-source software that is used to serve web pages and other content over the internet.

## Requirements.
- Virtual Machine - to test application locally.
- Homebrew - a package manager to install software.
- Docker desktop and docker installed.
- Any Browser - to access a running container using host's port.
- Terminal - used to build images and run containers.
- A Code Editor (VS Code) - to edit source code and dockerfiles.
- Git -for version control.

## Folder Structure.
- Module2 - main folder for this project.
  - img - contains screenshots of my progress while carrying out this task.
  - Task1 - contains folders which will be used to create 3 containers (1 php running on apache, 1 mysql and 1 phpmyadmin) that will connect on the same network.
    - data - contains the `sql` file that will be mounted to the mysql container as a volume.
    - php - contains the `.html` and `.php` source code.
    - .env - contains the sensitive credentials required.
    - Dockerfile - contains the instructions that will be used the build the php-apache image.
  - Task2 -contains the necessary folder requirements that will be used to create a php container linked to a database.
    - db - contains database table requirements that will be mounted on the database (automatically creates the database and tables).
    - src - contains source code written in php and html.
    - .env - contains the sensitive credentials required.
    - docker-compose.yml - a file that simplifies how multiple containers are created (instead of using docker run command multiple times). 
  - .dockerignore - contains files and folders that should be excluded when building a docker image.
  - .gitignore - contains files and folders that should not be tracked by git.
  - docker-commands - contains all docker commands used while working on this task.
  - README.md - contains the detailed steps and guidelines for this project. 

## The steps taken involves 3 stages and they are:
- Testing the application locally to ensure the application is functional. 
- Containerizing the application using dockerfile.
- Containerizing the application using docker-compose.

#### Stage 1: Testing the application locally to ensure the application is functional.
- The following modules and dependencies will be installed on my Ubuntu VM:
  - `sudo apt update` - to update the system repository.
  - `sudo apt install apache2` - to install apache2 which will be used as our web server.
  - `sudo apt install php` - installs php.
  - `sudo apt install php-mysql` - installs a PHP module that allows PHP to communicate with MySQL-based databases.
  - `sudo apt install mysql-server` - installs mysql server.
  - `sudo ufw allow "Apache"` - allows traffic on Apache (Port 80) through the fire wall with Ubuntu's default firewall configuration tool called Uncomplicated Firewall (UFW).
- Verify that apache is installed and accessible through firewall by viewing the default Apache web page with `http://<ip-address>` on your browser.
- This stage involves some configurations such as:
  - `sudo apache2ctl -M` - checks the Apache HTTP server.
  - `sudo a2dismod mpm_event` - disables event MPM module (a2dismod is used to disable a module).
  ![](img/php1.png)
  - `sudo a2enmod mpm_prefork` - enables pre-fork MPM module.
  - `sudo a2enmod php8.1` - enables the version of the php you installed (make sure to leave no space between php and the version number).
  ![](img/php2.png)
  - `sudo nano /etc/apache2/sites-available/<name>.conf` - Open a new configuration file in Apache’s `sites-available` directory with your preferred editor (when editing the file, do not forget to add your IP as the virtual host).
  ![](img/php4.png)

  - Create a virtual host (which will be used to encapsulate configuration details and host more than one domain from a single server) for our website (apache's virtual host is hosted `/var/www/html` directory),The following will be done:
     - Create a new directory with `sudo mkdir <directoryname>`
     - Create and edit the `form.html` and `form_submit.php` file.
     - Copy the files created above to the `/var/www/myproject` folder.
     - Change ownership to the current user, change permission.
     - Disable apache's default website with `sudo a2dissite 000-default`.
     - Ensure configuration file doesn’t contain syntax errors with `sudo apache2ctl configtest`
     - Enable the new virtual host with `sudo a2ensite <name>`.
     - Reload Apache so these changes take effect with `sudo systemctl reload apache2`.
  ![](img/php8.png)
  ![](img/php5.png)
  ![](img/php7.png)
  ![](img/php6.png)
     - I'll also edit the `/etc/apache2/mods-enabled/dir.conf` file so as to modify the order in which the `form.html` and `form_submit.php` file is listed within the DirectoryIndex directive.
  ![](img/php8_1.png)
     - Reload Apache so these changes take effect with `sudo systemctl reload apache2`.
- After installing mysql-db which will be used to store and manage data for your site, it’s recommended to run a security script that comes pre-installed with MySQL, which will remove some insecure default settings and lock down access to your database system
![](img/php-sql-error.png)
- I had some authentication issues and needed to adjust how my root MySQL user authenticates by:
  - Opening up the MySQL prompt with `sudo mysql` and changing the root user’s authentication method to one that uses a password with `ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '<somevaluehere>';`
![](img/sql.png)
- Exit the mysql prompt with `exit`.
- Run the interactive script using `sudo mysql_secure_installation` to configure the VALIDATE PASSWORD PLUGIN.
![](img/sql1.png)
- Also,this will remove some anonymous users and the test database, disable remote root logins, and load these new rules so that MySQL immediately respects the changes you have made.
![](img/sql2.png)
- After the script is completed, reopen mysql (with the root user's new password) and change the root user's authentication method to the default.
![](img/sql3.png)
- Create a new user and a new database.
![](img/sql4.png)
- With the `use` statement, I'll change the current db to the named database and also create a new table named `martians`.
![](img/sql5.png)
- Next, I'll be granting the newly created user appropriate privileges (Take note to only grant the required privileges and not give user total control over the database).
![](img/sql6.png)
- Using the `FLUSH PRIVILEGES` command reloads the grant tables to ensure that the new privileges are put into effect.
![](img/sql7.png)
- You can also view privileges granted to a user.
![](img/sql8.png)
- Login as new user. 
![](img/sql9.png)
- Fill and submit the form and check if it was impacted on the database.
![](img/sql10.png)

#### Stage 2: Containerizing the application using dockerfile.
- Download and install [homebrew](https://brew.sh/) and verify installation using `brew`
- Install docker via brew using `brew install --cask docker`, it also installs docker-compose automatically.
- Create project folders using the guide provided in folder structure.
- Navigate to project folder containing dockerfile and create a network with `docker network create --driver bridge <networkname>`.
- Build image using `docker build -t my-php-app . `, where `my-php-app` is my preferred name and `.` is the current directory.
![](img/build.png)
- Create 3 containers from images with:
  - `docker run -d -p 7080:80 -v ./php:/var/www/html --env-file .env --network test-network --name app my-php-app` - this container runs in a detached mode and maps container port 80 to the host's external port 7080 (which will be used to access the container on my browser), adds source code as a volume (this will be used to persist data even when the container is stopped and restarted), adds the env file, attaches the network earlier created and gives the container a custom name.
  - `docker run -d --name db --network test-network -v dbdata:/var/lib/mysql -v ./data:/docker-entrypoint-initdb.d -e MYSQL_ROOT_PASSWORD=ninja1 -e MYSQL_DATABASE=feedback -e MYSQL_USER=kene -e MYSQL_PASSWORD=passwordtest -p 3307:3306 mysql:latest` - adds required credentials as environment variables, attaches network, maps port and adds sql file as a volume (to create table on the database once the container is created).
  - `docker run -d --name interface -e PMA_HOST=db  --network test-network -p 7081:80 phpmyadmin:latest` - adds a container name, an environment variable (PMA_HOST which define host name of the MySQL server), attaches a network, maps port and lastly the image with a tag (where the container will be built from).
  - Output from containers running on localhost using their ports:
   - php-apache container - `localhost:7080/index.html`
   ![](img/task1-form.png)
   - Success message after the form is submitted.
   ![](img/task1-submit.png)

   - phpmyadmin container - `localhost:7081`
   ![](img/myadmin.png)
   - database table values (mounting my data folder automatically created my table on the web interface).
   ![](img/db.png)


#### Stage 3: Containerizing the application using docker-compose.
- Navigate to project folder on your code editor (VS code in my case), and create nesessary files (docker compose, .env, sql, html and php file).
- On the docker compose file (which is a `yml` file), specify the version and the services (which is an array of containers which are to be built and run together when the docker-compose file is executed).
- For each service, specify the service name, image, ports, environment variables, volumes etc.
- On the `.env` file, specify the envrironment variables and credentials (it is advisable to put environment variables and credentials in an .env file so as to manage sensitive information consistently while maintaining its security).
- `docker-compose up --build` - command builds the services, pulls the images and creates containers from those images, creates a network and attaches the network to the containers.

- Output from containers running on localhost using their ports: it is similar to step 2 but with different ports: `localhost:8080/index.html` and `localhost:8081`.

## Docker Commands used. 
- `docker info` - displays system wide information (such as kernel version, number of containers and images) regarding the Docker installation
- `docker version` - displays the current version of docker installed on the user's machine.
- `docker-compose up --build` - builds and starts multiple containers.
- `docker-compose down` - stops and removes containers, volumes, networks, and images created by `docker-compose up`.
- `docker inspect <networkname> /<containername>` - used to inspect a network or container.
- `docker logs <containerid>` -shows information logged by a running container.
- `docker-compose ps -a ` - shows a list of all containers (both running and exited containers).
- `docker network rm <networkname>` - removes a network using the network name.
- `docker images` - shows a list of all images.
- `docker rmi <image(s)>` - removes image(s).
- `docker network create --driver bridge <networkname>` - used to create a new network.
- `docker run -d -p 7080:80 -v ./php:/var/www/html --env-file .env --network test-network --name app my-php-app` - runs a php-apache container.
- `docker run -d --name interface -e PMA_HOST=db  --network test-network -p 7081:80 phpmyadmin:latest` - runs a phpmyadmin container.
- `docker run -d --name db --network test-network -v dbdata:/var/lib/mysql -v ./data:/docker-entrypoint-initdb.d -e MYSQL_ROOT_PASSWORD=ninja1 -e MYSQL_DATABASE=feedback -e MYSQL_USER=kene -e MYSQL_PASSWORD=passwordtest -p 3307:3306 mysql:latest` - runs a mysql container.
- `docker stop <containerid>` - used to stop a container.
- `docker restart <containerid>` - used to restart a container to test for data persistence.

## Best Practices Observed.
- Used a .env file to store and manage sensitive information.
- Created a .dockerignore file to store sensitive files to be excluded when building an image.
- Created a .gitignore file to store files that will not be tracked by git.
- Applied the principle of least privilege, I created another mysql user and restricted privileges.
- Used official images as base images.

## Over and Above
- A work in progress!!!

## Challenges Encountered.
- __Challenge 1__: I encountered an access denied error while trying to submit the form which will write data to mysql database.
- __Cause__: this was caused by comment on my .env file (apparently, .env is a text file and does not recognize commented lines). 
- __Solution__: this was resolved by removing comments and extra spaces from .env file.
![](img/sql-error.png)

- __Challenge 2__: I encountered a could not find driver error while trying to submit the form which will write data to mysql database.
- __Cause__: this was caused by the absence of the required PHP extensions. 
- __Solution__: this was resolved by adding PHP extension that will connect the PHP Apache to the MySQL server on the dockerfile.
![](img/sql-error1.png)

- __Challenge 3__: I encountered issues with accessing phpmyadmin.
- __Cause__: this was caused by invalid login details. 
- __Solution__: this was resolved by using the appropriate login details (for both other user and root while testing).

<!-- GRANT SELECT, INSERT, CREATE ON `feedback`.* TO `kene`@`%` WITH GRANT OPTION; -->

