# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
    source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;


export EDITOR=/usr/local/bin/emacs
export PYTHONPATH=$PYTHONPATH:/Users/andrew/research/brio:/Users/andrew/research/disparity:/Users/andrew/lib/LAHMC/python:/Users/andrew/research/MJHMC:/Users/andrew/lib/NUTS:/Users/andrew/research/hdnet:/Users/andrew/lib/tensorflow/tensorflow:/Users/andrew/research/ct_microscopy:/Users/andrew/projects/lstm_redditor:/Users/andrew/projects/arbitrary:/Users/andrew/research/division_detection:/Users/andrew/research/latentdendrite

# Starts jupyter on the remote server and starts a tunnel on local machine

# Usage: jupyter-remote remote-name@remote-server
#     > By default, it uses port 8332 on the remote machine and 8333 on the local machine.
#     > Optionally, the environment and ports can be specified as:
#                   jupyter-remote remote-name@remote-server environment local-port remote-port

jupyter-remote () {
    printf '\nSSH connection : %s\n'          $1
    printf 'Environment    : %s\n'            ${2-tensorflow}
    printf 'Tunnel         : %d --> %d\n\n'   ${4-8334} ${3-8335}

    ssh $1 source /groups/turaga/home/castonguayp/anaconda3/bin/activate ${2-tensorflow} > /dev/null 2>&1
    printf '\n'
    ssh $1 jupyter notebook --no-browser --port=${3-8335} &
    printf '\n'
    ssh -N -f -L localhost:${3-8334}:localhost:${4-8335} $1
    printf '\n'

    read -n 1 -s                 # Wait for keypress to remember it is still open
    printf 'Killing local listener:  '
    fuser -n tcp -k ${3-8334} >1 # Kills listener on local computer
}

# added by Anaconda3 4.0.0 installer
export PATH="/Users/andrew/anaconda/bin:$PATH"

export TF_ENV="/Users/andrew/anaconda/envs/tensorflow/lib/python3.5/site-package"

# tensorboard alias, obviously
alias 'tensorboard=python ~/anaconda/envs/tensorflow/lib/python3.5/site-packages/tensorflow/tensorboard/tensorboard.py'

ssh-tunnel () {
    ssh -N -f -L localhost:${2-6007}:localhost:${3-6006} $1
}
source /Users/andrew/anaconda/bin/activate.sh
n
