#!/bin/bash

opt=$1

if [ "$opt" == "--help" ]; then
	echo "Lists color names and hexadecimal values"
	echo "   *** Usage: $0 [--help|--brief]"
	exit 0
fi

# color list as a declarative array
declare -A cl

function add(){
	cl[$1]=$2
}

add red FF0000
add blue 0000FF
add green 00FF00
add black 000000
add white 00FF00
add pink FFC0CB
[ "$opt" != "--brief" ] && add deeppink FF1493
add orange FFA500
[ "$opt" != "--brief" ] && add orangered FF4500
[ "$opt" != "--brief" ] && add gold FFD700
add yellow FFFF00
[ "$opt" != "--brief" ] && add fuchsia FF00FF
add purple 800080
[ "$opt" != "--brief" ] && add darkmagenta 8B008B
[ "$opt" != "--brief" ] && add indigo 4B0082
add darkgreen 008000
[ "$opt" != "--brief" ] && add lightgreen 7FFF00
add cyan 00FFFF
[ "$opt" != "--brief" ] && add steelblue 4682B4
[ "$opt" != "--brief" ] && add deepskyblue 00BFFF
add darkblue 00008B
[ "$opt" != "--brief" ] && add midnightblue 191970
[ "$opt" != "--brief" ] && add goldenrod DAA520
[ "$opt" != "--brief" ] && add brown 8B4513
[ "$opt" != "--brief" ] && add azure F0FFFF
[ "$opt" != "--brief" ] && add silver C0C0C0
add gray 808080
[ "$opt" != "--brief" ] && add darkgray A9A9A9
[ "$opt" != "--brief" ] && add dimgray 696969
[ "$opt" != "--brief" ] && add lightgray d3d3d3


# Iterate on the keys of cl
for k in ${!cl[*]}; do
	echo "$k:${cl[$k]}"
done | sort | column

