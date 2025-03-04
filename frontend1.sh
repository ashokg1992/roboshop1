script_location=$(pwd)

echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y

echo -e "\e[35m remove old nginx content\e[0m"


echo -e "\e[35m download frontend old content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[35m Install Nginx\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html

echo -e "\e[35m extract frontend content\e[0m"
unzip /tmp/frontend.zip

echo -e "\e[35m Copy RoboShop Nginx Config File\e[0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf


echo -e "\e[35m  enable nginx\e[0m"
systemctl enable nginx

echo -e "\e[35m  enable restart nginx\e[0m"
systemctl restart nginx
