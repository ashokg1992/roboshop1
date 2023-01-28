script_location=$(pwd)
source common.sh
print_head "Copy MongoDB Repo file"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}

yum install mongodb-org -y &>>${LOG}

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
systemctl enable mongod &>>${LOG}
systemctl start mongod
systemctl restart mongod &>>${LOG}