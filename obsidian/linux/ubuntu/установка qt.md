#cpp #linux 

```bash
sudo apt-get install build-essential libssl-dev libxcb-xinerama0 libxkbcommon-x11-dev libfontconfig1-dev
```

```bash
tar -xvf qt-everywhere-src-6.7.2.tar.xz
cd qt-everywhere-src-6.7.2
```

```bash
sudo apt install cmake
```

```bash
./configure -prefix /usr/local/Qt-6.7.2 -opensource -confirm-license -nomake examples -nomake tests
```

```bash
make -j$(nproc)
sudo make install
```

```bash
export PATH=/usr/local/Qt-6.7.2/bin:$PATH
```

```bash
source ~/.bashrc
```

```bash
qmake --version
```