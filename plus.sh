source error.sh
source fpmul.sh

plus() #@ USAGE: plus  NUM NUM => $
{
  regexp='^(-)'
  regexp2='^([-+]?[0-9]+\.[0-9]*)'
  negative=false
  negative2=false
  fraction=false

  if [ $# -eq 0 ] || [ $# -gt 2 ]
  then
    error_exit "Cannot calculate this expression! Aborting"
  elif [ $# -eq 1 ]
  then
    if [[ $1 =~ $regexp ]]; then
      negative=true
    fi
    if [[ $1 =~ $regexp2 ]]; then
      fraction=true
    fi
    if $fraction ; then 
      fpmul $1 1000
      a=${_FPMUL}
      if $negative ; then      
        printf "%.1f\n" "$((-1 * ( $a + $a )))e-3"
      else
        printf "%.1f\n" "$(( $a + $a ))e-3"
      fi
    else
      echo $(( $1 + $1 ))
    fi
  else
    if [[ $1 =~ $regexp ]] ; then
      negative=true
    fi
    if [[ $2 =~ $regexp ]] ; then
      negative2=true
    fi
    if [[ $1 =~ $regexp2 ]] || [[ $2 =~ $regexp2 ]]; then
      fraction=true
    fi
    if $fraction ; then 
      fpmul $1 1000
      a=${_FPMUL}
      fpmul $2 1000
      b=${_FPMUL}
      if $negative && $negative2; then 
        printf "%.1f\n" "$((-1 * ( $a + $b )))e-3"
      elif $negative; then 
        printf "%.1f\n" "$(( $b - $a))e-3"
      elif $negative2; then
        printf "%.1f\n" "$(( $a - $b))e-3"
      else
        printf "%.1f\n" "$(( $a + $b ))e-3"
      fi
    else
      echo $(( $1 + $2 ))
    fi    
  fi
}