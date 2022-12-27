#!/bin/bash
start_time=`date +%s.%N`
path=$1

if [ ! -d $path ]
then
    echo "Directory DOES NOT exists."
    exit 1
fi

number_of_folders=$(($( find $path -type d | grep -e "." -c) - 1))
echo "Total number of folders (including all nested ones) = $number_of_folders"

path_in="$path""*"
top_size_folders=$(du -sh $path_in | sort -nr | awk '{print NR, "-", $2,", ", $1}' | head -n 5)
echo "TOP 5 folders of maximum size arranged in descending order (path and size):
$top_size_folders"

number_of_files=$(find $path -type f | wc -l)
echo "Total number of files = $number_of_files"

echo "Number of:"
number_of_conf_files=$(find $path -name "*.conf" | wc -l)
echo "Configuration files (with the .conf extension) = $number_of_conf_files"
number_of_text_files=$(find $path -name "*.txt" | wc -l)
# number_of_text_files=$(find $path -type f -readable | wc -l)
echo "Text files = $number_of_text_files"
number_of_executable_files=$(find $path -executable -type f | wc -l)
echo "Executable files = $number_of_executable_files"
# find $path -executable -type f
number_of_log_files=$(find $path -type f | grep -e "\.log" -c)
echo "Log files (with the extension .log) = $number_of_log_files"
number_of_archive_files=$(find $path -name '*.gz' | wc -l)
echo "Archive files = $number_of_archive_files"
number_of_symbolic_links=$(ls -lR | grep -e "^l" -c)
echo "Symbolic links = $number_of_symbolic_links"

top_size_files=$(find $path  -type f -print0 | xargs -r0 du -ah | sort -nr | head -10 | \
    awk 'BEGIN {ORS=" "}; {print NR, " - ", $2, ", ", $1, ","; split($2,str,"."); print str[NF]; print "\n"}')
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):
$top_size_files"

exec_top10="$(sudo find $1 -type f -executable -exec du -h {} + | sort -hr | head -10 | awk '{print $2}')"
exec_top10_size="$(sudo find $1 -type f -executable -exec du -h {} + | sort -hr | head -10 | awk '{print $1}')"
ExecT10=($exec_top10)
ExecT10size=($exec_top10_size)

echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
for (( i = 1; i < 11; i++ )); do
    if [[ ${ExecT10[$i]} ]]; then
        printf "%d - " "$i"
        printf "${ExecT10[$i]}, "
        printf "${ExecT10size[$i]}, "
        printf "$(sudo md5sum ${ExecT10[$i]} | awk '{print $1}')\n"
    fi
done

end_time=`date +%s.%N`

scripexectime=$( echo "$end_time - $start_time" | bc -l )
echo "Script execution time (in seconds) = $scripexectime"