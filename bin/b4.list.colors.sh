#!/bin/bash

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
add deeppink FF1493
add orange FFA500
add orangered FF4500
add gold FFD700
add yellow FFFF00
add fuchsia FF00FF
add purple 800080
add darkmagenta 8B008B
add indigo 4B0082
add darkgreen 008000
add lightgreen 7FFF00
add cyan 00FFFF
add steelblue 4682B4
add deepskyblue 00BFFF
add darkblue 00008B
add midnightblue 191970
add goldenrod DAA520
add brown 8B4513
add azure F0FFFF
add silver C0C0C0
add gray 808080
add darkgray A9A9A9
add dimgray 696969
add lightgray d3d3d3


# Iterate on the keys of cl
for k in ${!cl[*]}; do
	echo "$k:${cl[$k]}"
done | sort | column

