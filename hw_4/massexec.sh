#!/bin/bash

PARAMS=""
while (( "$#" )); do
  case "$1" in
    --path)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MY_FLAG_ARG=$2
        dirpath="$MY_FLAG_ARG"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --mask)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MY_FLAG_ARG=$2
        mask="$MY_FLAG_ARG"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
     --number)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MY_FLAG_ARG=$2
        number="$MY_FLAG_ARG"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    *)
      PARAMS="$PARAMS $1"
      command="$PARAMS"
      shift
      ;;
  esac
done


for parname in dirpath mask command number; do
  declare -n par=$parname
  if [ -z "$par" ]; then
    echo "$parname is unset"
    exit 1
  fi
done

function next_file() {
    declare -n arr="files"
    if [ ${#arr[@]} -gt 0 ]; then
      NEXT_FILE="${arr[${#arr[@]}-1]}"
      unset "arr[${#arr[@]}-1]"
      return 0
    fi
    return 1
}

declare -r path="$dirpath/$mask"
declare -a files=( $path )
file_count=${#files[@]}
declare -i LEFT_COUNT=$file_count
min=$((number < file_count ? number : file_count))
for _ in $(seq 1 $min); do
    next_file
    eval $command $NEXT_FILE &
done
while : ; do
  wait -n
  LEFT_COUNT=$((LEFT_COUNT-1))
  if [ ${#files[@]} -gt 0 ]; then
      next_file
      eval $command $NEXT_FILE &
  fi
  if [ $LEFT_COUNT -eq 0 ]; then
      break
  fi
done
wait
echo 'END'