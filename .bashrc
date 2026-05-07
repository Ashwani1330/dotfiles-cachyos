#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


# --- ROS 2 & NVIDIA SETUP (Dynamically handles Jazzy and Humble Distroboxes) ---

# Check if ANY ROS 2 installation exists in the current environment
if [ -f /opt/ros/jazzy/setup.bash ] || [ -f /opt/ros/humble/setup.bash ]; then

    # 1. Force Qt apps to use X11 and NVIDIA offloading (Common for both)
    export QT_QPA_PLATFORM=xcb
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export PATH="/usr/bin:$PATH"

    # 2. Version-Specific Sourcing
    if [ -f /opt/ros/jazzy/setup.bash ]; then
        source /opt/ros/jazzy/setup.bash

        # Source local workspaces (Update path to match your generic directory structure)
        [ -f ~/dev/robotics/workspace/install/setup.bash ] && source ~/dev/robotics/workspace/install/setup.bash

        ROS_CURRENT_DISTRO="Jazzy"

    elif [ -f /opt/ros/humble/setup.bash ]; then
        source /opt/ros/humble/setup.bash

        # NOTE: Ensure you create a separate workspace directory for Humble!
        # Source local workspaces (Update path to match your generic directory structure)
        [ -f ~/dev/robotics/humble_workspace/install/setup.bash ] && source ~/dev/robotics/humble_workspace/install/setup.bash

        ROS_CURRENT_DISTRO="Humble"
    fi

    # 3. Source colcon argcomplete if it exists
    if [ -f /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash ]; then
        source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
    fi

    export ROS_DOMAIN_ID=10
    # export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
    export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

    # Using $HOME makes this portable across different machines/usernames
    # export FASTRTPS_DEFAULT_PROFILES_FILE="$HOME/fastdds_profile.xml"
    export CYCLONEDDS_URI=file:///home/<user>/cyclonedds.xml
    # export ROS_DISABLE_SHARED_MEMORY=1

    # 4. Universal Build Helper
    build() {
        if [ -d "src" ]; then
            if colcon build --symlink-install; then
                source install/setup.bash
                echo "✅ $ROS_CURRENT_DISTRO Build successful and sourced."
            else
                echo "❌ $ROS_CURRENT_DISTRO Build FAILED. Check the errors above."
                return 1
            fi
        else
            echo "❌ Error: Not in a ROS 2 workspace root."
        fi
    }

    alias dep="rosdep install --from-paths src --ignore-src -y"

    export IGN_IP=127.0.0.1
    export IGN_PARTITION=amr_sim
fi

# --- NVM SETUP ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
