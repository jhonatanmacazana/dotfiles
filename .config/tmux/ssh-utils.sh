#/bin/bash

# exit the script if any statement returns a non-true return value
set -e

_is_enabled() {
  [ x"$1" = x"true" ] || [ x"$1" = x"yes" ] || [ x"$1" = x"enabled" ] || [ x"$1" = x"1" ]
}

_tty_info() {
  tty="${1##/dev/}"
  case "$_uname_s" in
  *CYGWIN*)
    ps -al | tail -n +2 | awk -v tty="$tty" '
        ((/ssh/ && !/-W/) || !/ssh/) && $5 == tty {
          user[$1] = $6; parent[$1] = $2; child[$2] = $1
        }
        END {
          for (i in parent)
          {
            j = i
            while (parent[j])
              j = parent[j]

            if (!(i in child) && j != 1)
            {
              file = "/proc/" i "/cmdline"; getline command < file; close(file)
              gsub(/\0/, " ", command)
              "id -un " user[i] | getline username
              print i":"username":"command
              exit
            }
          }
        }
      '
    ;;
  *)
    ps -t "$tty" -o user=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -o pid= -o ppid= -o command= | awk '
        NR > 1 && ((/ssh/ && !/-W/) || !/ssh/) {
          user[$2] = $1; parent[$2] = $3; child[$3] = $2; pid=$2; $1 = $2 = $3 = ""; command[pid] = substr($0,4)
        }
        END {
          for (i in parent)
          {
            j = i
            while (parent[j])
              j = parent[j]

            if (!(i in child) && j != 1)
            {
              print i":"user[i]":"command[i]
              exit
            }
          }
        }
      '
    ;;
  esac
}

_ssh_or_mosh_args() {
  case "$1" in
  *ssh*)
    args=$(printf '%s' "$1" | perl -n -e 'print if s/(.*?)\bssh\b\s+(.*)/\2/')
    ;;
  *mosh-client*)
    args=$(printf '%s' "$1" | sed -E -e 's/.*mosh-client -# (.*)\|.*$/\1/' -e 's/-[^ ]*//g' -e 's/\d:\d//g')
    ;;
  esac

  printf '%s' "$args"
}

_username() {
  tty=${1:-$(tmux display -p '#{pane_tty}')}
  ssh_only=$2

  tty_info=$(_tty_info "$tty")
  command=${tty_info#*:}
  command=${command#*:}

  ssh_or_mosh_args=$(_ssh_or_mosh_args "$command")
  if [ -n "$ssh_or_mosh_args" ]; then
    # shellcheck disable=SC2086
    username=$(ssh -G $ssh_or_mosh_args 2>/dev/null | awk '/^user / { print $2; exit }')
    # shellcheck disable=SC2086
    [ -z "$username" ] && username=$(ssh -T -o ControlPath=none -o ProxyCommand="sh -c 'echo %%username%% %r >&2'" $ssh_or_mosh_args 2>&1 | awk '/^%username% / { print $2; exit }')
  else
    if ! _is_enabled "$ssh_only"; then
      username=${tty_info#*:}
      username=${username%%:*}
    fi
  fi

  printf '%s\n' "$username"
}

_hostname() {
  tty=${1:-$(tmux display -p '#{pane_tty}')}
  tty_info=$(_tty_info "$tty")
  command=${tty_info#*:}
  command=${command#*:}

  ssh_or_mosh_args=$(_ssh_or_mosh_args "$command")
  if [ -n "$ssh_or_mosh_args" ]; then
    # shellcheck disable=SC2086
    hostname=$(ssh -G $ssh_or_mosh_args 2>/dev/null | awk '/^hostname / { print $2; exit }')
    # shellcheck disable=SC2086
    [ -z "$hostname" ] && hostname=$(ssh -T -o ControlPath=none -o ProxyCommand="sh -c 'echo %%hostname%% %h >&2'" $ssh_or_mosh_args 2>&1 | awk '/^%hostname% / { print $2; exit }')

    case "$hostname" in
    *[a-z-].*)
      # hostname=${hostname%%.*} # removes .com|.tk|.ga|...
      hostname="@${hostname}"
      ;;
    127.0.0.1)
      hostname="localhost"
      ;;
    esac
  else
    if ! _is_enabled "$ssh_only"; then
      # hostname=$3
      hostname=""
    fi
  fi

  printf '%s\n' "$hostname"
}

_root() {
  tty=${1:-$(tmux display -p '#{pane_tty}')}
  root=${2:-'!'}

  username=$(_username "$tty" false)

  [ x"$username" = x"root" ] && echo "$root"
}

_publicip() {
  echo "$(curl icanhazip.com)"
}

_ip_addr() {
  echo " $(ifconfig eth0 | grep 'inet ' | awk '{print "lan " $2}')"
}

_vpn0_addr() {
  out = $(ifconfig tun0 | grep 'inet ' | awk '{print "vpn " $2}')
  [ -z $out ] echo " $(ifconfig tun0 | grep 'inet ' | awk '{print "vpn " $2}')"
}

_vpn1_addr() {
  out = $(ifconfig tun1 | grep 'inet ' | awk '{print "vpn " $2}')
  [ -z $out ] echo " $(ifconfig tun1 | grep 'inet ' | awk '{print "vpn " $2}')"
}

_ping_googledns() {
  _dr="8.8.8.8"
  _pg=$(ping -c1 $_dr | grep ttl | cut -f4 -d'=')
  printf ' %s (%s)' "$_dr" "$_pg"
}

_ping_default_gateway() {
  _dr=$(ip route show | grep default | cut -d' ' -f 3)
  _pg=$(ping -c1 $_dr | grep ttl | cut -f4 -d'=')
  printf ' %s (%s)' "$_dr" "$_pg"
}

_uptime() {
  echo " $(uptime | awk '{print $3}' | sed 's/,//') UT"
}

"$@"
