#!/bin/bash

# 在blog目录调用
# 如果文件格式不对, 使用dos2unix转换
# 例如 file 201608/20160823_01.md
#      201608/20160823_01.md: UTF-8 Unicode C program text, with CRLF line terminators 说明需要转换 
# 例如 dos2unix -c ASCII -o ./20161031_02.md 
#      dos2unix: converting file ./20161031_02.md to UNIX format ...

> ./README.md
echo "### PostgreSQL Greenplum 培训视频分享  " > ./README.md
echo "  "  >> ./README.md
echo "http://pan.baidu.com/s/1pKVCgHX  ,  如果连接失效请通知我, 谢谢  " >> ./README.md
echo "  "  >> ./README.md
echo "![pic](./pic/pg_china_digoal_video.jpg)  " >> ./README.md
echo "  "  >> ./README.md
echo "作者个人水平有限, 如发现错误, 请指正, 非常感谢.  "  >> ./README.md
echo "  "  >> ./README.md
echo "欢迎转载(注明出处), 如有问题, 可以在这里发issue讨论, 或者微信联系我  " >> ./README.md
echo "  "  >> ./README.md
echo "### 二维码  " >> ./README.md
echo "![pic](./pic/pg_china_weixin.jpg)  " >> ./README.md
echo "![pic](./pic/pg_china_weibo.jpg)  " >> ./README.md
echo "![pic](./pic/pg_china_digoal.jpg)  " >> ./README.md
echo "  "  >> ./README.md
echo "### digoal,德哥的PostgreSQL私房菜  " >> ./README.md

for dir in `ll|awk '{print $9}'|grep -E '^[0-9]{6}'` 
do
  cd $dir
  echo "### 文章列表  "  > ./readme.md
  echo "----  "  >> ./readme.md
  echo "----  " >> ../README.md
  for file in `ll *.md|awk '{print $9}'|grep -E '^[0-9]{8}'` 
  do 
    title=`head -n 1 $file|awk -F "##" '{print $2}'|sed 's/^[ ]*//; s/[ ]*$//'`
    echo "##### $file   [《$title》]($file)  " >> ./readme.md
    echo "##### $dir/$file   [《$title》]($dir/$file)  " >> ../README.md
  done
  cd ..
done
