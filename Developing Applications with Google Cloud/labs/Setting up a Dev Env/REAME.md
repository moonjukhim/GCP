# Node.js

### Task 2: Install software on the VM instance

```bash
sudo apt-get update
sudo apt-get install git
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install nodejs

```

### Task 3: Configure the VM to Run application software

```bash
node -v
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/developingapps/v1.2/nodejs/devenv ~/devenv
cd ~/devenv
sudo node server/app.js

npm install
node list-gce-instances.js
```

# Python

```bash
sudo apt-get update
sudo apt-get install git
sudo apt-get install python3-setuptools python3-dev build-essential
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
python3 --version
pip3 --version
```

```
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/developingapps/v1.2/python/devenv ~/devenv
cd ~/devenv/

sudo python3 server.py
```