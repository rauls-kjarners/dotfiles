#!/bin/bash

# Monitor D-Bus for color-scheme changes
dbus-monitor --session "type='signal',interface='org.freedesktop.portal.Settings',member='SettingChanged'" | while read -r line; do
    if echo "$line" | grep -q "color-scheme"; then
        # Query current theme
        theme=$(gdbus call --session --dest=org.freedesktop.portal.Desktop --object-path=/org/freedesktop/portal/desktop --method=org.freedesktop.portal.Settings.Read org.freedesktop.appearance color-scheme | awk -F'uint32 ' '{print $2}' | tr -d '>\)')
        
        # 1 = Dark, 2 = Light (0 = Default/No Preference, which usually maps to Light)
        if [ "$theme" = "1" ]; then
            fish -c "switch_theme dark"
        else
            fish -c "switch_theme light"
        fi
    fi
done
