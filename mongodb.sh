script_location=$(pwd)

cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}

yum install mongodb-org -y &>>${LOG}


systemctl enable mongod &>>${LOG}
systemctl start mongod
systemctl restart mongod &>>${LOG}