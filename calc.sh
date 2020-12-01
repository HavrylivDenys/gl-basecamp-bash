#!/usr/bin/env bash

source fpmul.sh
source error.sh
source plus.sh
source minus.sh

Main() {
  EXP=$1
  regexp='^([-+]?[0-9]+\.?[0-9]*)(\+|\-|\*)([-+]?[0-9]+\.?[0-9]*)$'

  if [ $# -eq 0 ] || [ $# -gt 1 ]; then 
      echo "Basic calculator in bash. It supports only (+)(-)(*). You can use float numbers. Enjoy!"
      echo "USAGE: operand(number) operator operand(number) without spaces."
      exit 1
  fi

  if [[ $EXP =~ $regexp ]]; then
    # BASH_REMATCH[1] - first operand BASH_REMATCH[2] - operator BASH_REMATCH[3] - second operand
    
    a=${BASH_REMATCH[1]}
    operator=${BASH_REMATCH[2]}
    b=${BASH_REMATCH[3]}    

    case $operator in
      "*")
        fpmul $a $b
        echo $_FPMUL
        exit 0
        ;;
      "+")
        result=$(plus $a $b) 
        echo $result
        exit 0
        ;;
      "-")
        result=$(minus $a $b) 
        echo $result
        exit 0
        ;;
    esac
    
  else
    error_exit "Cannot calculate this expression! Aborting"
  fi
}

Main $1