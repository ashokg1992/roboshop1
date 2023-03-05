script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo "Refer Log file for more information, LOG - ${LOG}"
    exit 1
  fi
}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}

APP_PREREQ() {

  print_head "Add Application User"
  id roboshop &>>${LOG}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${LOG}
  fi
  status_check

  mkdir -p /app &>>${LOG}

  print_head "Downloading App content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  status_check

  print_head "Cleanup Old Content"
  rm -rf /app/* &>>${LOG}
  status_check

  print_head "Extracting App Content"
  cd /app
  unzip /tmp/${component}.zip &>>${LOG}
  status_check

}

SYSTEMD_SETUP() {
  print_head "Configuring ${component} Service File"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
  status_check

  print_head "Reload SystemD"
  systemctl daemon-reload &>>${LOG}
  status_check

  print_head "Enable ${component} Service "
  systemctl enable ${component} &>>${LOG}
  status_check

  print_head "Start ${component} service "
  systemctl start ${component} &>>${LOG}
  status_check
}

LOAD_SCHEMA() {
  if [ ${schema_load} == "true" ]; then

    if [ ${schema_type} == "mongo"  ]; then
      print_head "Configuring Mongo Repo "
      cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
      status_check

      print_head "Install Mongo Client"
      yum install mongodb-org-shell -y &>>${LOG}
      status_check

      print_head "Load Schema"
      mongo --host mongodb-dev.muralidevops.online </app/schema/${component}.js &>>${LOG}
      status_check
    fi

    if [ ${schema_type} == "mysql"  ]; then

      print_head "Install MySQL Client"
      yum install mysql -y &>>${LOG}
      status_check

      print_head "Load Schema"
      mysql -h mysql-dev.muralidevops.online -uroot -p${root_mysql_password} < /app/schema/shipping.sql  &>>${LOG}
      status_check
    fi

  fi
}


   NODEJS() {
    source common.sh

    print_head "Configuring Nodejs Repos"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
    status_check

    print_head "Install Nodejs "
    yum install nodejs -y &>>${LOG}
    status_check

    print_head "Add Application User"
    useradd roboshop &>>${LOG}
    id roboshop &>>${LOG}
    if [ $? -ne 0 ]; then
      useradd roboshop &>>${LOG}
    fi
    status_check

    mkdir -p /app &>>${LOG}

    print_head "Downaloading App content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
    status_check

    print_head "Cleanup Old Content"
    rm -rf /app/* &>>${LOG}
    status_check

    print_head "Extracting App Content"
    cd /app
    unzip /tmp/${component}.zip &>>${LOG}
    status_check

    print_head "Installing Nodejs Dependencies"
    cd /app &>>${LOG}
    npm install &>>${LOG}
    status_check

    print_head "Configuring ${component} Service File"
    cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
    status_check

    print_head "Reload SystemD"
    systemctl daemon-reload &>>${LOG}
    status_check

    print_head "Enable ${component} Service "
    systemctl enable ${component} &>>${LOG}
    status_check

    print_head "Start ${component} Service "
    systemctl start ${component} &>>${LOG}
    status_check

    print_head "Configuring Mongo Repo "
    cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
    status_check

    print_head "Install Mongo Clinet"
    yum install mongodb-org -y &>>${LOG}
    status_check

    print_head "Load Schema"
    mongo --host mongodb-dev.muralidevops.online </app/schema/${component}.js &>>${LOG}
    status_check
   }

MAVEN() {

  print_head "Install Maven"
  yum install maven -y &>>${LOG}
  status_check

  APP_PREREQ

  print_head "Build a package"
  mvn clean package  &>>${LOG}
  status_check

  print_head "Copy App file to App Location"
  mv target/${component}-1.0.jar ${component}.jar
  status_check

  SYSTEMD_SETUP

  LOAD_SCHEMA

}


