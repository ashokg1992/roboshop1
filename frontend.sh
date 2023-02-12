script_location=$(pwd)

eco -e "\e[35m install Nginx\e[0m"
yum install nginx -y

eco -e "\e[35m Remove Nginx old content\e[0m"
rm -rf /usr/share/nginx/html/*

eco -e "\e[35m Downlaod Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html

eco -e "\e[35m Extract Frontend Extract\e[0m"
unzip /tmp/frontend.zip

eco -e "\e[35m Copy Roboshop Nginx Config File\e[0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

eco -e "\e[35m Enable Nginx\e[0m"
systemctl enable nginx

eco -e "\e[35m Start Nginx\e[0m"
systemctl restart nginx