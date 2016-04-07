
#!/bin/bash

yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel
yum install xz-libs
pkg="Python-2.7.9.tar.xz"
rm -vf ${pkg}{.asc,}
set -o errexit
wget https://www.python.org/~peterson/pubkey.asc
wget https://www.python.org/ftp/python/2.7.9/${pkg}{.asc,}
#md5sum -c Python-2.7.9.tar.xz.md5 || ( echo "checksum dont match " && exit 1  )
gpg  --import pubkey.asc
gpg  --verify ${pkg}{.asc,}
ls
rm -vf Python-2.7.9.tar
xz -d Python-2.7.9.tar.xz
tar xvf Python-2.7.9.tar
cd Python-2.7.9
#--enable-shared is needed for mod_wsgi recompile
./configure --prefix=/usr/local --enable-shared
make
#install to /usr/local/ dont overwrite the system default
make altinstall
echo $?
# Add to path
echo "#installed python2.7 on $(date +%D) " >> ~/.bashrc
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
. ~/.bashrc

###hmm might be just for reinstall 
cat > /etc/ld.so.conf.d/python2.7 <<EOF
/usr/local/lib
EOF
ldconfig
#for rhel 6 it was not enough to just call the ldconfig 
ldconfig /usr/local/lib
ldd /usr/local/bin/python2.7

#validation
which python2.7
python2.7  -V
python2.7  -c   'print "hello world";'
#make 2.7 default for this user
ln -s  /usr/local/bin/python2.7 /usr/local/bin/python
which python
python -V
#curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python2.7 -
#pip 8.1 
curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo python2.7
