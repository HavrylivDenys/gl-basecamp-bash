fpmul() #@ USAGE: fpmul  NUM NUM ... => $_FPMUL
{
  local places tot qm neg n int dec df
  places=
  tot=1
  qm=
  neg=
  for n
  do
      ## 2 negatives make a positive
      case $n in
	  -*) [ "$neg" = '-' ] && neg= || neg='-'
	      n=${n#-}
	      ;;
      esac

      ## Check for non-numeric characters
      case $n in
          *[!0-9.]*) return 1 ;;
      esac

      ## count the number of decimal places,
      ## then remove the decimal point
      case $n in
          .*) int=
	      dec=${n#?}
	      places=$places$dec
              n=$dec
	      ;;
	  *.*) dec=${n#*.}
	       int=${n%.*}
	       places=$places$dec
               n=$int$dec
	       ;;
      esac

      ## remove leading zeroes
      while :
      do
        case $n in
            ""|0) n=0
                _FPMUL=0
                return
                ;;
            0*) n=${n#0} ;;
            *) break;;
        esac
      done

      ## multiply by the previous total
      tot=$(( $tot * ${n:-0} ))

      ## report any overflow error
      case $tot in
          -*) printf "fpmul: overflow error: %s\n" "$tot" >&2
              return 1
              ;;
      esac
    done

    while [ ${#tot} -lt ${#places} ]
    do
      tot=0$tot
    done

    df=
    while [ ${#df} -lt ${#places} ]
    do
      left=${tot%?}
      df=${tot#$left}$df
      tot=$left
    done
    _FPMUL=$tot${df:+.$df}

    ## remove trailing zeroes or decimal points
    while :
    do
      case $_FPMUL in
          *.*[0\ ]|*.) _FPMUL=${_FPMUL%?} ;;
          .*)  _FPMUL=0$_FPMUL ;;
          *) break ;;
      esac
    done
}

# The scipt was taken from https://cfajohnson.com/shell/?2012-11-08_floating_point_multiplication. Thank you.