if [ -r /etc/environment ]; then
    set -o allexport
    . /etc/environment
    set +o allexport
fi

export HOME="$(awk -F: "/$(id -u)/{print \$6}" /etc/passwd)"
