#!/usr/bin/docker
#     ____             __             ____  ______  __
#    / __ \____  _____/ /_____  _____/ __ \/ ___/ |/ /
#   / / / / __ \/ ___/ //_/ _ \/ ___/ / / /\__ \|   / 
#  / /_/ / /_/ / /__/ ,< /  __/ /  / /_/ /___/ /   |  
# /_____/\____/\___/_/|_|\___/_/   \____//____/_/|_|  
# 
# Repo:             https://github.com/sickcodes/Docker-OSX/
# Title:            Mac on Docker (Docker-OSX)
# Author:           Sick.Codes https://sick.codes/ 
# Version:          2.6
# License:          GPLv3+
# 
# All credits for OSX-KVM and the rest at @Kholia's repo: https://github.com/kholia/osx-kvm
# OpenCore support go to https://github.com/Leoyzen/KVM-Opencore 
# and https://github.com/thenickdude/KVM-Opencore/
# 
# This Dockerfile automates the installation of Docker-OSX
# It will build a 200GB container. You can change the size using build arguments.
# This Dockerfile builds on top of the work done by Dhiru Kholia, and many others.
#       
# Build:
#
#       docker build -t docker-osx .
#       docker build -t docker-osx --build-arg VERSION=10.15.5 --build-arg SIZE=200G .
#       
# Basic Run:
#       
#       docker run --device /dev/kvm --device /dev/snd -v /tmp/.X11-unix:/tmp/.X11-unix -e "DISPLAY=${DISPLAY:-:0.0}" sickcodes/docker-osx:latest
#
#
# Run with SSH:
# 
# 
#       docker run --device /dev/kvm --device /dev/snd -e RAM=6 -p 50922:10022 -v /tmp/.X11-unix:/tmp/.X11-unix -e "DISPLAY=${DISPLAY:-:0.0}" sickcodes/docker-osx:latest
#       # ssh fullname@localhost -p 50922
# 
# Optargs:
#       
#       SIZE=200G
#       VERSION=10.15.6
#       ENV RAM=5
#       ENV SMP=4
#       ENV CORES=4
#       ENV EXTRA=
#       ENV INTERNAL_SSH_PORT=10022
#
# Extra QEMU args:
#
#       docker run ... -e EXTRA="-usb -device usb-host,hostbus=1,hostaddr=8" ...
#       # you will also need to pass the device to the container
#

FROM sickcodes/docker-osx:latest

MAINTAINER 'https://sick.codes' <https://sick.codes>

# change disk size here or add during build, e.g. --build-arg VERSION=10.14.5 --build-arg SIZE=50G
ARG SIZE=200G
ARG VERSION=10.15.6

# This fails on hub.docker.com, useful for debugging in cloud
# RUN [[ $(egrep -c '(svm|vmx)' /proc/cpuinfo) -gt 0 ]] || { echo KVM not possible on this host && exit 1; }

WORKDIR /root

ENV USER arch

ENV DISPLAY=:0.0

USER arch

VOLUME ["/tmp/.X11-unix"]

WORKDIR /home/arch/OSX-KVM

CMD ./enable-ssh.sh && envsubst < ./Launch.sh | bash

# virt-manager mode: eta son
# CMD virsh define <(envsubst < Docker-OSX.xml) && virt-manager || virt-manager
# CMD virsh define <(envsubst < macOS-libvirt-Catalina.xml) && virt-manager || virt-manager
