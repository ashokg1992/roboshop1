script_location=$(pwd)
source common.sh
print_head "Copy MongoDB Repo file"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}

yum install mongodb-org -y &>>${LOG}


systemctl enable mongod &>>${LOG}
systemctl start mongod
systemctl restart mongod &>>${LOG}