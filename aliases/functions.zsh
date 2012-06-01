# ---------------------------------------------
# - general functions for every day shell-ing -
# ---------------------------------------------

# exiting (not so) gracefully by killing the process
function angry_exit {
  echo "${txtred}⚡⚡⚡ kthxbye!${txtrst}"
  kill -SIGINT $$
}

# exiting (not so) gracefully by killing the process
function happy_exit {
  echo "${txtgrn}☼ kthxbye...${txtrst}"
  kill -SIGINT $$
}

# add to nocorrect list
function blacklist {
  echo "$1" >> ~/.oh-my-zsh/custom/zsh_nocorrect
  echo "ok"
}

# go to project folder
function cdmy {
  cd ~/Projects/$1
}

# opens an application from /Applications
function go {
  open "/Applications/$1.app"
}

# open man pages in Preview
function pdfman() {
  man $1 -t | open -f -a Preview;
}

# todo list manager v2
# run:
#   todo <scope>
# where scope is 'global' or 'local'
function todo {
  ok_notice="${txtylw}--> OK${txtrst}"
  case $1 in
    "global")
      echo "${txtgrn}${txtbld}<<GLOBAL SCOPE>>${txtrst}"
      todos_file=$HOME/Dropbox/.todos
      ;;
    "local")
      echo "${txtgrn}${txtbld}<<LOCAL SCOPE>>${txtrst}"
      todos_file=$HOME/.todos
      ;;
    "edit")
      # ask for global or local todo source to edit
      echo -n "Enter scope of todo file to edit (global/local): "
      read scope
      
      if [ "$scope" = "global" ]
      then
        $EDITOR $HOME/Dropbox/.todos
      else
        $EDITOR $HOME/.todos
      fi
      
      echo "${ok_notice} ($scope todo source file opened using '$EDITOR')"
      happy_exit
      ;;
    *)
      echo "no scope specified!"
      angry_exit
      ;;
  esac
  
  echo "Enter TODO tasks! ('help' for available commands)"
  while [ true ]; do
    read todo
    case $todo in
      "list") . "$todos_file" && echo "$ok_notice";;
      "quit") echo "$ok_notice (bye!)" && break;;
      "help") echo "--> commands: help, kill, list, quit";;
      "kill") rm $todos_file && echo "" >> $todos_file && echo "$ok_notice (all tasks removed)";;
      *) echo "echo -e '- $todo'" >> $todos_file && echo "$ok_notice (task added)";;
    esac
  done
}

# swap-
# stores small snippets, urls, etc. in cloud
# run:
#   swap set
#   swap get
function swap {
  ok_notice="${txtylw}--> OK${txtrst}"
  source_file=$HOME/Dropbox/.swap
  case $1 in
    "status")
      word_count="$(wc -l ~/Dropbox/.swap | cut -d "/" -f1 | tr -d ' ')"
      echo "${txtcyn}There are $(echo "$word_count - 1" | bc) rows in the swapfile.${txtrst}"
      ;;
    "kill")
      rm $source_file && echo "" >> $source_file
      echo "${ok_notice} (swap erased)"
      ;;
    "set")
      echo "${txtcyn}Add to swapfile:${txtrst}"
      read todo
      # add date tag: date +"%m-%d-%Y %H:%M"
      # add tag support
      echo "[tag][date]$todo" >> $source_file
      echo "${ok_notice} (swap written)"
      ;;
    "get")
      cat $source_file
      echo "${ok_notice} (end of file)"
      ;;
    "edit")
      $EDITOR $source_file
      echo "${ok_notice} (swap file opened using '$EDITOR')"
      ;;
    "help")
      echo "commands: get, set, kill, status, edit, help"
      echo "e.g. swap get"
      ;;
    *)
      echo "swap what? (type 'swap help' for instructions)"
      angry_exit
      ;;
  esac
}

# broadcast
# sends a message to another box (one-way transmission)
# run:
#   broadcast <command> <box-name>
# e.g.:
#   (1) broadcast setup unagi
#   (2) broadcast send sashimi
#   (3) broadcast receive (optional: box-name)
# where <box-name> is the unique identifier of the remote box as set up in the remote .box-name
#
# (1) this command sets up the required files (~/.boxname and ~/Dropbox/.unagi-box)
#             -> ~/.boxname includes the name of the local box => unagi
#             -> ~/Dropbox/.unagi-box will hold the broadcast messages
# (2) this command sends a message to the remote box via Dropbox
#             -> stores a message in ~/Dropbox/.sashimi-box if that file exists
# (3) this command displays any received messages for the current box (or an optionally passed box name)
#             -> displays message of your local box (e.g. ~/Dropbox/.unagi-box)
#             -> if other box name specified, it acts accordingly
#
# messages are tagged with a timestamp (date +"%m-%d-%Y %H:%M") and the source box name, e.g. [05-31-2012 16:59][unagi] message foo bar
# commands: send, receive, setup, help
function broadcast {
  # WIP
}

# check or go to a drive volume
function drive {
  if [ -z "$1" ]; then
    ( cd /Volumes && ls )
  else
    cd /Volumes/$1
    # requires figlet (fink install figlet)
    echo "${txtylw}"
    figlet $1
    echo "${txtrst}"
    df -h |grep -i $1
  fi
}

# check number of unread emails
function gmail {
  curl -u $MAILNAME@$1.com:$(cat ~/.oh-my-zsh/custom/.$1) --silent 'https://mail.google.com/mail/feed/atom' | sed -n 's|<fullcount>\(.*\)</fullcount>|\1|p'
}

