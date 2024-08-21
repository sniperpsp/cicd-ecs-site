#!/bin/bash

# Criar usuário template com senha Te#mpl@te e dar permissões de root
useradd template #criando usuario
echo 'template:Te#mpl@te' | chpasswd #senhad o usuario
usermod -aG wheel template #permissão de root para o usuario

# Habilitar login com usuário e senha
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config  #habilitando acesso com senha via ssh
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config #habilitando acesso com senha via ssh
sed -i 's/^#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config #habilitando acesso com senha via ssh
sed -i 's/^PermitEmptyPasswords yes/PermitEmptyPasswords no/' /etc/ssh/sshd_config #habilitando acesso com senha via ssh


# Reiniciar o serviço SSH para aplicar as mudanças
systemctl restart sshd

# Instalar Apache e unzip
sudo yum update -y
sudo yum install httpd unzip -y

#Instalar Docker e Git
sudo yum update -y
sudo yum install git -y
sudo yum install docker -y
sudo usermod -a -G docker template
id ec2-user ssm-user
sudo newgrp docker
sudo systemctl start httpd
sudo systemctl enable httpd
sudo /home/ec2-user/bia/build.sh

# Baixar e descompactar o site
curl -L -o /tmp/Website.zip https://github.com/sniperpsp/terraform-template/raw/main/Website.zip    #Aqui vou baixar o site na pasta /tmp com o nome Website.zip, você pode trocar site 
sudo unzip /tmp/Website.zip -d /tmp #descompactando o zip, importante  trocar o nome do zip se você baixar com outro nome
sudo mkdir /var/www/html/teste1 #criando a pasta onde vai ser habilitado o site
sudo mv /tmp/site/* /var/www/html/teste1 #movendo o conteudo do site para a pasta que vai ser o front do apache < mude a origem de acordo com seu arquivo>
sudo chown -R apache:apache /var/www/html/teste1 
sudo chmod -R 755 /var/www/html/teste1

# Criar arquivo de configuração do Apache para o site
cat <<EOL | sudo tee /etc/httpd/conf.d/teste1.conf
<VirtualHost *:80>
    DocumentRoot "/var/www/html/teste1"
    ServerName localhost

    <Directory "/var/www/html/teste1">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOL

# Reiniciar o serviço Apache para aplicar as mudanças
sudo systemctl restart httpd

#Ativar docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

#Instalar docker compose 2
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose


#Adicionar swap
sudo dd if=/dev/zero of=/swapfile bs=128M count=32
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile swap swap defaults 0 0" >> /etc/fstab


#Instalar node e npm
curl -fsSL https://rpm.nodesource.com/setup_21.x | sudo bash -
sudo yum install -y nodejs