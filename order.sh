bash rmtasklogs.sh

if [[ -z `R --version 2>/dev/null` ]]
then
 echo "Run: sudo yum install R"
 exit
fi
: 'if [[ -z `R -q -e "library(RESS)" | grep no\ package` ]]
then
 echo ""
 echo "Run: sudo R"
 echo " then: install.packages(\"RESS\")"
 exit
fi'

echo $# #| sed 's/.* //' #| tr ' ' ','
count=1
#myout=`find . -name *order.txt `
#echo $myout
#while [[ -n `echo $myout | grep / 2>/dev/null` ]]
#do
# myout=`$myout | sed 's/\///' `
# count=`expr $count + 1`
# echo $myout
# echo `echo $myout | grep / 2>/dev/null`
#done
echo $count
ivar=0
jvar=0
kvar=0
for i in `cat order.txt`
do
 if [ -e $i/order.txt ]
 then
  echo "READING: "$i/order.txt
  for j in `cat $i/order.txt`
  do
    if [ -e $i/$j/order.txt ]
    then
     echo "READING: "$i/$j/order.txt
     for k in `cat $i/$j/order.txt`
     do
      if [ -e $i/$j/$k/order.txt ]
      then
#       cat $i/$j/$k/order.txt
      bash executeorder.sh $i $j $k
      elif [ $kvar -eq 0 ]
      then
       kvar=1
#       cat $i/$j/order.txt
       bash executeorder.sh $i $j
      fi
     done
     kvar=0
    elif [ $jvar -eq 0 ]
    then
     jvar=1
#     cat $i/order.txt
     bash executeorder.sh $i
    fi
  done
  jvar=0
 elif [ $ivar -eq 0 ]
 then
  ivar=1
#  cat order.txt
  bash executeorder.sh
 fi
done
ivar=0

if [[ -n `find . -name *cred* 2>/dev/null` ]]
then
 for file in `find . -name *cred* 2>/dev/null`
 do
  rm -f $file
 done
fi

