current1='\-notitle'
current2=" -notitle"
replace=" -o,notitle -"
current1='\-udb_imp'
current2=" -udb_imp"
replace=" -udb -imp"


IFS=$'\n'
for file in `grep -R "$current1" * | grep -v task.log | grep -v sed.sh | awk -F':' '{print $1}'`
do
 echo $file
 sed -i "s/$current2/$replace/g" $file
done
