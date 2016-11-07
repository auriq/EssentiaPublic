if [[ -n `find . -name task.log 2>/dev/null` ]]
then
 for file in `find . -name task.log 2>/dev/null`
 do
  rm -f $file
 done
fi
