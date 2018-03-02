FROM ubuntu:16.04
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install build-essential net-tools git sudo wget libssl-dev libboost-all-dev redis-server

# Install nvm
ENV NVM_DIR /usr/local/nvm
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
ENV NODE_VERSION 0.10.29
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use --delete-prefix $NODE_VERSION"
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

RUN /bin/bash -c "source $NVM_DIR/nvm.sh && npm install -g npm@1.3.10 && npm update"

# # Get pool source code 
RUN git clone https://github.com/cyyber/node-cryptonote-pool.git pool
ADD config.json /pool/

RUN /bin/bash -c "source $NVM_DIR/nvm.sh && cd /pool && npm install -g npm@1.3.10 && npm update"

RUN update-rc.d redis-server defaults
