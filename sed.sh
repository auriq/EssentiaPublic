IFS=$'\n'
for file in `grep -R "\-notitle" * | grep -v task.log | grep -v sed.sh | awk -F':' '{print $1}'`
do
 echo $file
 sed -i 's/ -notitle/ -o,notitle -/g' $file
done
