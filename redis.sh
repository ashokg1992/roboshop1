source common.sh

print_head "Setup Redis Repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "Enable Redis 6.2 dnf Module"
dnf module enable redis:remi-6.2 -y &>>${LOG}
status_check

print_head "Install Redis"
yum install redis -y &>>${LOG}
status_check

print_head "Update Redis Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG}
status_check

print_head "Enable Redis"
systemctl enable redis &>>${LOG}
status_check

print_head "Start Rediss"
systemctl restart redis &>>${LOG}
status_check