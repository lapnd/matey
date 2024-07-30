#!/usr/bin/env bash
set -x
set -e

# Determine the architecture
case $(uname -m) in
  arm64)
    export ARCH=arm64
    ;;
  amd64|x86_64)
    export ARCH=amd64
    ;;
esac

# Determine the operating system
case $(uname -s) in
  Linux)
    export OS=linux
    # Further check for distribution
    if [[ -f /etc/redhat-release ]]; then
      # CentOS/RHEL
      sudo yum update -y || sudo dnf update -y
      sudo yum install -y jq tmux curl || sudo dnf install -y jq tmux curl
    elif [[ -f /etc/debian_version ]]; then
      # Debian/Ubuntu
      sudo apt-get update
      sudo apt-get install -y jq tmux curl
    else
      echo "Unsupported Linux distribution"
      exit 1
    fi

    # Get the latest ttyd release version
    LATEST_TTYD=$(curl -s https://api.github.com/repos/tsl0922/ttyd/releases/latest | jq -r .tag_name)
    TTYD_URL="https://github.com/tsl0922/ttyd/releases/download/$LATEST_TTYD/ttyd.x86_64"

    # Download and install ttyd
    sudo curl -L -o /usr/local/bin/ttyd $TTYD_URL
    sudo chmod 0755 /usr/local/bin/ttyd

    # Check ttyd version
    ttyd --version
    ;;
  Darwin)
    brew install ttyd tmux curl
    export OS=darwin
    ;;
  *)
    echo "Unsupported OS"
    exit 1
    ;;
esac

# Install tunnel from GitHub release
TUNNEL_RELEASE=v0.1.14
TUNNEL_URL=https://github.com/ii/wgtunnel/releases/download/$TUNNEL_RELEASE/tunnel-$OS-$ARCH
sudo curl -L -o /usr/local/bin/tunnel $TUNNEL_URL
sudo chmod 0755 /usr/local/bin/tunnel

# Check versions
tmux -V
ttyd --version
/usr/local/bin/tunnel --version

# Add /usr/local/bin to PATH if not already present
echo $PATH | grep /usr/local/bin >/dev/null || echo "You may want to add /usr/local/bin to your PATH"

# Install iimatey script from GitHub
sudo curl -L -o /usr/local/bin/iimatey https://raw.githubusercontent.com/ii/matey/canon/iimatey
sudo chmod +x /usr/local/bin/iimatey
