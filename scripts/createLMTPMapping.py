import os
import sys

domainList = []
lmtpHostList = []
lmtpFile='/etc/postfix/transport'

# get domain and hosts
for env in os.environ:
    try:
        if 'RELAY_HOST_PAIR' in env:
            domainList.append(os.environ[env].split(',')[0])
            lmtpHostList.append(os.environ[env].split(',')[1])
    except IndexError:
        print("Wrong format in parameter {} with value {} ...".format(env,os.environ[env]))
        sys.exit(1)



# create postfix lmtp transport file
open(lmtpFile, 'w').close() # delete existing file

for i in range(0, len(domainList)):
    with open(lmtpFile, "a") as transportFile:
        transportFile.write(
            domainList[i] + " lmtp:[" + lmtpHostList[i] + "]:2003\n")
    print('registered :' + domainList[i])

sys.exit(0)