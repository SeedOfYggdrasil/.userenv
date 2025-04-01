
#!/data/data/com.termux/files/usr/bin/bash

# sshctl.sh v. 0.9

CONFIG_FILE="$PREFIX/etc/ssh/sshd_config"
SSH_PORT=$(grep -E '^Port ' $CONFIG_FILE | awk '{print $2}')
FIREWALL_RULES="/data/data/com.termux/files/home/.ssh-firewall-rules"

detect_conflict() {
    CONFLICT_PID=$(lsof -ti tcp:$SSH_PORT)
    if [[ -n "$CONFLICT_PID" ]]; then
        echo "⚠️  Port $SSH_PORT is in use by another process (PID: $CONFLICT_PID)."
        echo "Run: sshctl force-restart to free the port."
        return 1
    fi
    return 0
}

case "$1" in
    status)
        if pgrep -x sshd > /dev/null; then
            echo "✅ sshd is running on port $SSH_PORT."
        else
            echo "❌ sshd is not running."
        fi
        ;;

    start)
        detect_conflict || exit 1
        nohup sshd &>/dev/null &
        echo "✅ sshd started on port $SSH_PORT."
        ;;

    stop)
        pkill -9 sshd
        echo "❌ sshd stopped."
        ;;

    restart)
        pkill -9 sshd
        detect_conflict || exit 1
        nohup sshd &>/dev/null &
        echo "🔄 sshd restarted on port $SSH_PORT."
        ;;

    force-restart)
        echo "🔍 Identifying processes using SSH port ($SSH_PORT)..."
        for pid in $(lsof -ti tcp:$SSH_PORT); do
            echo "🔪 Killing process: $pid"
            kill -9 $pid
        done
        echo "🔄 Restarting sshd..."
        nohup sshd &>/dev/null &
        echo "✅ sshd forcefully restarted."
        ;;

    enable)
        mkdir -p ~/.termux/boot
        echo "#!/data/data/com.termux/files/usr/bin/bash" > ~/.termux/boot/start-sshd
        echo "sshd" >> ~/.termux/boot/start-sshd
        chmod +x ~/.termux/boot/start-sshd
        echo "✅ sshd enabled on boot."
        ;;

    disable)
        rm -f ~/.termux/boot/start-sshd
        echo "❌ sshd disabled from boot."
        ;;

    open-ports)
        echo "🛠 Opening SSH port $SSH_PORT..."
        echo "iptables -A INPUT -p tcp --dport $SSH_PORT -j ACCEPT" > $FIREWALL_RULES
        echo "iptables -A OUTPUT -p tcp --sport $SSH_PORT -j ACCEPT" >> $FIREWALL_RULES
        chmod +x $FIREWALL_RULES
        bash $FIREWALL_RULES
        echo "✅ Ports opened for SSH."
        ;;

    close-ports)
        echo "🛠 Closing SSH port $SSH_PORT..."
        iptables -D INPUT -p tcp --dport $SSH_PORT -j ACCEPT
        iptables -D OUTPUT -p tcp --sport $SSH_PORT -j ACCEPT
        rm -f $FIREWALL_RULES
        echo "❌ Ports closed for SSH."
        ;;

    set-port)
        if [[ -z "$2" ]]; then
            echo "❌ Error: Please specify a new port number."
            echo "Usage: sshctl set-port <new_port>"
            exit 1
        fi
        NEW_PORT=$2
        echo "🔄 Changing SSH port to $NEW_PORT..."
        sed -i "s/^Port $SSH_PORT/Port $NEW_PORT/" $CONFIG_FILE
        SSH_PORT=$NEW_PORT
        sshctl restart
        echo "✅ SSH port changed to $NEW_PORT."
        ;;

    *)
        echo "Usage: $0 {status|start|stop|restart|force-restart|enable|disable|open-ports|close-ports|set-port <port>}"
        ;;
esac
