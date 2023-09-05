#!/usr/bin/bash
#!/system/bin/sh

#
# Display 3 random locations on screen
#


SLEEPSEC=0.2
NORMAL="\e[49m"
GREEN="\e[102m"
RED="\e[101m"
YELLOW="\e[103m"
#--------------------------------------------------------------------

showHit ()
{
    LP=$1
    CP=$2
    
    COLOR=$(( ( RANDOM % 3 )  + 1 ))
    case "${COLOR}" in
    1) COLOR=$RED    ;;
    2) COLOR=$GREEN  ;;
    3) COLOR=$YELLOW ;;
    esac
    
    echo -e "${COLOR}\e[${LP};${CP}H xxx${NORMAL}"
    LP=$(($LP+1))
    echo -e "${COLOR}\e[${LP};${CP}H xxx${NORMAL}"
    LP=$(($LP+1))
    echo -e "${COLOR}\e[${LP};${CP}H xxx${NORMAL}"
}

showUL ()
{
    LP=2
    CP=$(($COLS/2 - 8))
    showHit $LP $CP
}
showUR ()
{
    LP=2
    CP=$(($COLS/2 + 8))
    showHit $LP $CP
}

showML ()
{
    LP=$(($LINS/2 - 1))
    CP=$(($COLS/2 - 8))
    showHit $LP $CP
}
showMR ()
{
    LP=$(($LINS/2 - 1))
    CP=$(($COLS/2 + 8))
    showHit $LP $CP
}

showLL ()
{
    LP=$(($LINS-4))
    CP=$(($COLS/2 - 8))
    showHit $LP $CP
}
showLR ()
{
    LP=$(($LINS-4))
    CP=$(($COLS/2 + 8))
    showHit $LP $CP
}

#--------------------------------------------------------------------
left ()
{
    LOCATION=$(( ( RANDOM % 3 )  + 1 ))
    case "${LOCATION}" in
    1) clear && showUL && sleep $SLEEPSEC ;;
    2) clear && showML && sleep $SLEEPSEC ;;
    3) clear && showLL && sleep $SLEEPSEC ;;
    esac
}

right ()
{
    LOCATION=$(( ( RANDOM % 3 )  + 1 ))
    case "${LOCATION}" in
    1) clear && showUR && sleep $SLEEPSEC ;;
    2) clear && showMR && sleep $SLEEPSEC ;;
    3) clear && showLR && sleep $SLEEPSEC ;;
    esac
}

#--------------------------------------------------------------------

if [ "$#" -eq 1 ]; then 
    SLEEPSEC=$1
fi
echo "Usage: $0 $SLEEPSEC"

COLS=$COLUMNS
if [ -z "$COLS" ]; then
    COLS=$(tput cols)
fi
if [ -z "$COLS" ]; then
    COLS=80
fi

LINS=$LINES
if [ -z "$LINS" ]; then
    LINS=$(tput lines)
fi
if [ -z "$LINS" ]; then
    LINS=24
fi
echo "Geometry: $COLS x $LINS"

# break the loop on any key pressed
if [ -t 0 ]; then stty -echo -icanon -icrnl time 0 min 0; fi
keypress=''

while [ "x$keypress" = "x" ]; do
    clear
    sleep 0.1
    left

    clear
    sleep 0.1
    right
    
    keypress="`cat -v`"
done

if [ -t 0 ]; then stty sane; fi
