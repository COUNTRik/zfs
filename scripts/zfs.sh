# #!/bin/bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Устанавливаем необходимые пакеты
yum install -y yum-utils

# Устанавливаем zfs пакет с официального сайта и публичный ключ 
yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_8.noarch.rpm
gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinu

# Переключаем репозиторий zfs на kABI
yum-config-manager --enable zfs-kmod
yum-config-manager --disable zfs

# Проверяем репозиторий zfs
yum repolist

# Устанавливаем zfs
yum install -y zfs

# Загружаем модуль zfs для ядра
modprobe zfs
