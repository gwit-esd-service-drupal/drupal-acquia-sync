#!/bin/sh

set -e

SOURCE_REPO=$1
SOURCE_BRANCH=$2
SOURCE_SSH_PRIVATE_KEY=$3



echo "SOURCE=$SOURCE_REPO:$SOURCE_BRANCH"
#echo "DESTINATION=$DESTINATION_REPO:$DESTINATION_BRANCH"
#echo "DEVELOPMENT=$DEVELOPMENT_REPO:$DEVELOPMENT_BRANCH"

if [[ -n "$SOURCE_SSH_PRIVATE_KEY" ]]; then
  # Clone using source ssh key if provided
  eval `ssh-agent -s`
  echo '#!/bin/sh' > ~/.ssh_askpass
  echo 'echo $SOURCE_SSH_PASSPHRASE' >> ~/.ssh_askpass && chmod +x ~/.ssh_askpass
  echo "$(~/.ssh_askpass)"
  echo "$SOURCE_SSH_PRIVATE_KEY" | tr -d '\r' | DISPLAY=None SSH_ASKPASS=~/.ssh_askpass ssh-add - >/dev/null
  #git clone -c core.sshCommand="/usr/bin/ssh -i ~/.ssh/src_rsa" "$SOURCE_REPO" /root/source --origin source && cd /root/source
else
  git clone "$SOURCE_REPO" /root/source --origin source && cd /root/source
fi

#git remote add destination "$DESTINATION_REPO"
#git remote add development "$DEVELOPMENT_REPO"

# Pull all branches references down locally so subsequent commands can see them
#git fetch source '+refs/heads/*:refs/heads/*' --update-head-ok

# Print out all branches
#git --no-pager branch -a -vv

if [[ -n "$DESTINATION_SSH_PRIVATE_KEY" ]]; then
  # Push using destination ssh key if provided
 # git config --local core.sshCommand "/usr/bin/ssh -i ~/.ssh/dst_rsa"
fi

#git push destination --all 
#git push destination -f --tags 


#git push development "master:master" -f
#git push development -f --tags

