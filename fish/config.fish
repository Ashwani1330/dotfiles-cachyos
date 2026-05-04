source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
#    # smth smth
end

# Add this to the TOP of ~/.config/fish/config.fish on your host
if test -f /run/.containerenv -o -f /.dockerenv
    # We are inside a container
    if exec bash
    end
end
