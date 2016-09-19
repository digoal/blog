#!/bin/bash

# 在blog目录调用
# 如果文件格式不对, 使用dos2unix转换
# 例如 file 201608/20160823_01.md
# 201608/20160823_01.md: UTF-8 Unicode C program text, with CRLF line terminators 说明需要转换 

> ./README.md
echo "### digoal,德哥的PostgreSQL私房菜  " > ./README.md
echo "  " >> ./README.md

for dir in `ll|awk '{print $9}'|grep -E '^[0-9]{6}'` 
do
  cd $dir
  echo "### 文章列表  "  > ./readme.md
  echo "----  "  >> ./readme.md
  for file in `ll *.md|awk '{print $9}'|grep -E '^[0-9]{8}'` 
  do 
    title=`head -n 1 $file|awk -F "##" '{print $2}'|sed 's/^[ ]*//; s/[ ]*$//'`
    echo "##### $file   [《$title》]($file)  " >> ./readme.md
    echo "##### $dir/$file   [《$title》]($dir/$file)  " >> ../README.md
  done
  cd ..
done
