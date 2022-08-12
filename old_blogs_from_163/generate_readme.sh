#!/bin/bash

# 在blog目录调用
# 如果文件格式不对, 使用dos2unix转换
# 例如 file 201608/20160823_01.md
#      201608/20160823_01.md: UTF-8 Unicode C program text, with CRLF line terminators 说明需要转换 
# 例如 dos2unix -c ASCII -o ./20161031_02.md 
#      dos2unix: converting file ./20161031_02.md to UNIX format ...

> ./README.md
echo "### 以前写在163 BLOG的老文章陆续迁移至此,还有几千篇,体力不支了.  " > ./README.md

for dir in `ls -lr|awk '{print $9}'|grep -E '^[0-9]{6}'` 
do
  cd $dir
  echo "### 文章列表  "  > ./readme.md
  echo "----  "  >> ./readme.md
  echo "----  " >> ../README.md
  for file in `ls -lr *.md|awk '{print $9}'|grep -E '^[0-9]{8}'` 
  do 
    title=`head -n 1 $file|awk -F "##" '{print $2}'|sed 's/^[ ]*//; s/[ ]*$//'`
    echo "##### ${file}   [《${title}》](${file})  " >> ./readme.md
    echo "##### ${dir}/${file}   [《${title}》](${dir}/${file})  " >> ../README.md
  done
  cd ..
done
