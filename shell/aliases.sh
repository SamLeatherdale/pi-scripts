# Personal
alias code='code-oss'

# From https://www.reddit.com/r/raspberry_pi/comments/ewnttc/useful_my_standard_bash_aliases_commands_i/
alias reboot='sudo reboot'
alias rpi-update='sudo rpi-update'
alias shutdown='sudo shutdown -h 0'
alias temp='sudo vcgencmd measure_temp'
alias checktemp='sudo vcgencmd get_throttled'
alias clock='vcgencmd measure_clock arm'
alias volt='vcgencmd measure_volts'
alias yupdate='sudo apt-get update -y'
alias yupgrade='sudo apt-get upgrade -y'
alias yclean='df -h && sudo apt-get clean && df -h'
alias pip=pip3

# From https://opensource.com/article/19/7/bash-aliases
alias lt='ls --human-readable --size -1 -S --classify'
alias gh='history|grep'
alias left='ls -t -1'
alias count='find . -type f | wc -l'

# From https://opensource.com/article/18/9/handy-bash-aliases
alias ipi='ipconfig getifaddr en0'

# From https://superuser.com/questions/665274/how-to-make-ls-color-its-output-by-default-without-setting-up-an-alias
## Colorize the ls output ##
alias ls='ls --color=auto'

## Use a long listing format ##
alias ll='ls -l'
alias la='ls -la'

## Show hidden files ##
alias l.='ls -d .* --color=auto'