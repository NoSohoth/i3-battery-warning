#!/bin/bash

#
# Get battery info
#

# Main path
BATTERY=$(ls /sys/class/power_supply/ | grep '^BAT')
# ACPI path
ACPI_PATH="/sys/class/power_supply/$BATTERY"
# Battery status (Full, Discharging)
STAT=$(cat $ACPI_PATH/status)
# Remaining energy value
REM=`grep "POWER_SUPPLY_ENERGY_NOW" $ACPI_PATH/uevent | cut -d= -f2`
# Full energy value
FULL=`grep "POWER_SUPPLY_ENERGY_FULL_DESIGN" $ACPI_PATH/uevent | cut -d= -f2`
#Current energy value in percent
PERCENT=`echo $(( $REM * 100 / $FULL ))`


#
# Set energy limit in percent, where warning should be displayed
#
LIMIT="20"

#
# Show warning if energy limit in percent is less then user set limit and
# if battery is discharging
#
if [ $PERCENT -le "$(echo $LIMIT)" ] && [ "$STAT" == "Discharging" ]; then
    MESSAGE="Battery is low. $PERCENT% remaining."
    /usr/bin/i3-nagbar -m "$(echo $MESSAGE)"
fi

