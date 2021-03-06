branch=`git branch | grep \* | awk '{printf $2}'`

mypath=`echo $@ | tr ' ' '/'`

myfile="order.txt"
if [ -n "$mypath" ]
then
 newpath="$mypath"
#myfile="$mypath/order.txt"
else
 newpath="."
#myfile="order.txt"
fi

cd $newpath
currentpwd=`pwd`
#echo $currentpwd
outputpwd=`echo $currentpwd | sed "s/EssentiaPublic/EssentiaPublic\/output\/$branch/g"`
if [[ -z `ls $outputpwd 2>/dev/null` ]]
then
 mkdir -p $outputpwd
fi
#echo $outputpwd
IFS=$'\n'
lastfile=""
if [[ -n `cat $myfile | grep -e \\.R -e \\.sh` ]]
then
# cat $myfile
 for file in `cat $myfile`
 do
  outputfile=`echo $file | sed 's/\..*//g'`
  modfile=`echo $file | tr -d "'"`
  echo $file
  echo $modfile
  if [[ -n `echo $file | grep -e \\.sh` ]]
  then
   echo "bash $modfile"
   eval bash $modfile >$outputpwd/$outputfile.out 2>failure.txt
  elif [[ -n `echo $file | grep -e \\.R` ]]
  then
   if [[ "$file" != *"analyze"* ]]
   then
    echo "R -f $modfile"
    R -f $modfile >$outputpwd/$outputfile.out 2>failure.txt
   else
    echo 'R -e "source(\"$lastfile\")" -e "source(\"$modfile\")"', $lastfile, $modfile
    R -e "source(\"$lastfile\")" -e "source(\"$modfile\")" >$outputpwd/$lastfile$outputfile.out 2>failure.txt
   fi
  fi
 if [[ -n `grep errors failure.txt` ]]
 then
  echo "At $currentpwd, file $file failed. Used $modfile"
  orderpid=`ps -ef | grep order.sh | grep -v grep | grep -v executeorder | awk '{printf $2}'`
  echo $orderpid
  kill $orderpid
  exit
 fi
 rm failure.txt
 lastfile="$file"
 done
fi
cd -
