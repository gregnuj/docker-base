export HOME="$(awk -F: "/$(id -u)/{print \$6}" /etc/passwd)"

# include user .profile
if [ -f "$HOME/.profile" ]; then
	. "$HOME/.profile"
fi

# include user bashrc
if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
