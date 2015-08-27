#!/bin/bash
echo "Updating apt repositories..."
apt-get update


echo "Installing base packages..."
PACKAGES="build-essential zsh git vim-nox tree htop libjpeg-dev libfreetype6-dev graphviz gettext"
PACKAGES="$PACKAGES python python-setuptools python-pip python-dev"
PACKAGES="$PACKAGES postgresql-9.3 postgresql-server-dev-9.3"

apt-get install -y $PACKAGES


echo "Setting up PostgreSQL server..."
cp /tmp/templates/postgresql/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
service postgresql restart

USER_EXISTS=$(psql -U postgres -h localhost -tAc "SELECT 1 FROM pg_roles WHERE rolname='vagrant'" postgres)

if [ ! $USER_EXISTS ]; then
    sudo -Hu postgres bash -c 'createuser -dSR vagrant'
fi


echo "Installing Oh My Zsh!..."
OHMYZSH_DIR=/home/vagrant/.oh-my-zsh

if [ ! -d $OHMYZSH_DIR ]; then
    sudo -Hu vagrant bash -c "git clone https://github.com/robbyrussell/oh-my-zsh.git $OHMYZSH_DIR"
fi

cp /tmp/templates/zsh/zshrc /home/vagrant/.zshrc
cp /tmp/templates/zsh/zprofile /home/vagrant/.zprofile
chown vagrant:vagrant /home/vagrant/.zshrc
chown vagrant:vagrant /home/vagrant/.zprofile
chsh -s $(which zsh) vagrant


echo "Configuring virtualenv..."
VIRTUALENV_DIR=/home/vagrant/env

pip install virtualenv

if [ ! -d "$VIRTUALENV_DIR" ]; then
    mkdir $VIRTUALENV_DIR
    virtualenv $VIRTUALENV_DIR
    chown -R vagrant:vagrant $VIRTUALENV_DIR
fi


echo "Installing python dependencies..."
REQUIREMENTS_FILE=/home/vagrant/src/requirements/devel.txt

if [ -f "$REQUIREMENTS_FILE" ]; then
    sudo -Hu vagrant bash -c "source $VIRTUALENV_DIR/bin/activate && pip install -r $REQUIREMENTS_FILE"
fi

echo "Done."
