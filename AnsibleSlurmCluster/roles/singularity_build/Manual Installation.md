### Install required packages
```commandline
sudo apt-get install -y build-essential &&\
    libssl-dev &&\
    uuid-dev &&\
    libgpgme11-dev &&\
    squashfs-tools &&\
    libseccomp-dev &&\
    pkg-config &&\
    autoconf &&\
    automake &&\
    cryptsetup &&\
    libfuse-dev &&\
    libglib2.0-dev &&\
    libtool &&\
    runc &&\
    squashfs-tools-ng &&\
    glib-2.0
```

### Install go
```commandline
export VERSION=1.21.0 OS=linux ARCH=amd64
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz
sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz
rm go$VERSION.$OS-$ARCH.tar.gz
```

### Setup go Environment

```commandline
echo 'export GOPATH=${HOME}/go' >> ~/.bashrc && \
    echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc && \
    source ~/.bashrc
```

### Install Singularity from source
```commandline
export VERSION=4.0.1
mkdir -p $GOPATH/src/github.com/sylabs
cd $GOPATH/src/github.com/sylabs
wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz
tar -xzf singularity-ce-${VERSION}.tar.gz
cd ./singularity-ce-${VERSION}
```

#### Compile singularity
```commandline
./mconfig
make -C ./builddir
sudo make -C ./builddir install
```

### Hello World
```commandline
singularity pull --name hello-world.simg shub://vsoch/hello-world
singularity shell hello-world.simg
singularity exec hello-world.simg ls 
#Run the container
singularity run hello-world.simg
#if in same directory
./hello-world.simg
# if using uri instead (shub can be replaced with docker)
singularity run shub://GodloveD/lolcow
```

### Cleanup
```commandline
rm -rf $HOME/go
```

