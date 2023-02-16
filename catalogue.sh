script_location=$(pwd)
LOG=/tmp/roboshop.log

source common.sh

print_head "Configuring Nodejs Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install Nodejs "
yum install nodejs -y &>>${LOG}
status_check

print_head "Add Application User"
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
   useradd roboshop &>>${LOG}
fi
status_check

mkdir -p /app &>>${LOG}

print_head "Downaloading App content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

print_head "Cleanup Old Content"
rm -rf /app/* &>>${LOG}
status_check

print_head "Extracting App Content"
cd /app
unzip /tmp/catalogue.zip &>>${LOG}
status_check

print_head "Installing Nodejs Dependencies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head "Configuring Catalogue Service File"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "Reload SystemD"
systemctl daemon-reload &>>${LOG}
status_check

print_head "Enable Catalogue Service "
systemctl enable catalogue &>>${LOG}
status_check

print_head "Start Catalogue Service "
systemctl start catalogue &>>${LOG}
status_check

print_head "Configuring Mongo Repo "
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "Install Mongo Clinet"
yum install mongodb-org -y &>>${LOG}
status_check

print_head "Load Schema"
mongo --host monngdb.dev.muralidevops.online </app/schema/catalogue.js &>>${LOG}
status_check