#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2016-04-24 21:29:46 +0100 (Sun, 24 Apr 2016)
#
#  https://github.com/harisekhon/Dockerfiles
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback
#
#  https://www.linkedin.com/in/harisekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

export JAVA_HOME="${JAVA_HOME:-/usr}"

export PATH="$PATH:/hadoop/sbin:/hadoop/bin"

if [ $# -gt 0 ]; then
    exec "$@"
else
    if ! pgrep -x sshd &>/dev/null; then
        /usr/sbin/sshd
    fi
    echo
    SECONDS=0
    # while true; do
    #     if ssh-keyscan localhost 2>&1 | grep -q OpenSSH; then
    #         echo "SSH is ready to rock"
    #         break
    #     fi
    #     if [ "$SECONDS" -gt 20 ]; then
    #         echo "FAILED: SSH failed to come up after 20 secs"
    #         exit 1
    #     fi
    #     echo "waiting for SSH to come up"
    #     sleep 1
    # done
    echo
    mkdir -pv /hadoop/logs

    start-dfs.sh
    start-yarn.sh
    tail -f /dev/null /hadoop/logs/*
    stop-yarn.sh
    stop-dfs.sh
fi
