if [ -r /etc/environment ]; then
    set -o allexport
    . /etc/environment
    set +o allexport
fi
