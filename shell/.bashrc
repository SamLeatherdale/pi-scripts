# Add this to your real ~/.bashrc:
#   source $HOME/pi-scripts/shell/.bashrc

# https://stackoverflow.com/questions/6659689/referring-to-a-file-relative-to-executing-script/29409988#29409988
DIR="$(dirname "${BASH_SOURCE[0]}")"

source "$DIR/aliases.sh"