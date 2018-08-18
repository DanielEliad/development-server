FROM ubuntu:latest
MAINTAINER Daniel Eliad <daniel.eliad32@gmail.com>

RUN mkdir -p /run/sshd

RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d
RUN rm -rf /var/cache/apt/*
RUN apt-get update
RUN apt-get install -y vim git tmux fish wget unzip net-tools openssh-server
RUN useradd -d /home/developer -m -s /usr/bin/fish developer
RUN echo 'developer:toor' | chpasswd
RUN echo 'root:root' | chpasswd
EXPOSE 22

USER developer
WORKDIR /home/developer

# set up fish
RUN mkdir -p ~/.config/fish
RUN touch ~/.config/config.fish
RUN echo "abbr -a gl='git pull'\nabbr -a gp='git push'\nabbr -a gco='git checkout'\nabbr -a gd='git diff'\nabbr -a gc='git commit'\nabbr -a ga='git add'\ntmux" > ~/.config/fish/config.fish

# RUN wget https://www.fontsquirrel.com/fonts/download/ibm-plex -O ~/ibm-plex.zip
# RUN mkdir ~/ibm-plex && cd ~/ibm-plex
# RUN echo 'A' | unzip ~/ibm-plex.zip
# RUN cd ~
# RUN mv ~/ibm-plex /usr/share/fonts/ibm-plex
# RUN rm ~/ibm-plex.zip

RUN git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
RUN sh ~/.vim_runtime/install_awesome_vimrc.sh

RUN echo "set-option -g default-shell /usr/bin/fish\nset-option -g prefix C-q\nbind-key C-q last-window" >> ~/.tmux.conf

USER root
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
CMD /usr/sbin/sshd -D
