#!/bin/bash

flag=0
serialPort="/dev/ttyUSB0"

trap programExit SIGINT SIGKILL SIGTERM

subppid=$!
sleep 0.1

function programExit()
{
        kill $subppid
        exit
}

DATA[0]="SYSTEM"
DATA[1]="BOOTING"

declare -i length
isbusy=0

writeData () {
        echo -ne "\006" > $serialPort
        str=${1//\\}
        length=$((${#str} + 48))
        echo -ne $(printf \\$(printf '%03o' $length)) > $serialPort
        while [ "$isbusy" != 6 ]
        do
                isbusy=$(head -c 1 $serialPort)
        done
        echo -ne "$1" > $serialPort
        isbusy=0
}

writeData "\e[2s\e[1r"
writeData "\ec"
writeData "ver. 0.1-a"


writeData "\e[5s\e[1r"
#writeData "\ec"

while true
do
        for ((j=1; j<8; j++)); do
                writeData "\e[70;70f"
                for ((i=0; i<6; i++)); do
                        writeData "\e[3"$j"m\e[3"$j"m${DATA[0]:$i:1}"
                done
                writeData "\eE\e[55;120f"
                for ((i=0; i<7; i++)); do
                        writeData "\e[3"$j"m\e[3"$j"m${DATA[1]:$i:1}"
                done
        done
sleep 2
done     

