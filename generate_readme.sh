#!/bin/bash

# 在blog目录调用
# 如果文件格式不对, 使用dos2unix转换
# 例如 file 201608/20160823_01.md
#      201608/20160823_01.md: UTF-8 Unicode C program text, with CRLF line terminators 说明需要转换 
# 例如 dos2unix -c ASCII -o ./20161031_02.md 
#      dos2unix: converting file ./20161031_02.md to UNIX format ...
# 迁移从163 blog 63页 <数据挖掘学习站点收集>开始算新文章迁移到本级目录,之前的算老文章迁移到old_blogs_from_163

> ./README.md
echo "#### [About me](me/readme.md) " >> ./README.md
echo "  "  >> ./README.md
echo "### PostgreSQL, Greenplum 学习视频1  " >> ./README.md
echo "  "  >> ./README.md
echo "下载链接： http://pan.baidu.com/s/1pKVCgHX   (如果链接失效请通知我, 谢谢)  " >> ./README.md
echo "  "  >> ./README.md
echo "1、PostgreSQL 9.3 数据库管理与优化 视频4天  " >> ./README.md
echo "2、PostgreSQL 9.3 数据库管理与优化 视频5天  " >> ./README.md
echo "3、PostgreSQL 9.1 数据库管理与开发 视频1天  " >> ./README.md
echo "4、PostgreSQL 9.3 数据库优化 视频3天  " >> ./README.md
echo "5、PostgreSQL 专题讲座 视频  " >> ./README.md
echo "  "  >> ./README.md
echo "### PostgreSQL, Greenplum 学习视频2  " >> ./README.md
echo "  "  >> ./README.md
echo "[《PostgreSQL 生态、案例、开发实践、管理实践、原理、日常维护、诊断、排错、优化、资料。  含学习视频》](201801/20180121_01.md) " >> ./README.md 
echo "  "  >> ./README.md
echo "### 社区、个人微信二维码  " >> ./README.md
echo "![pic](./pic/pg_weixin.jpg)  " >> ./README.md
echo "  "  >> ./README.md
echo "### 钉钉PostgreSQL专家群、直播群二维码  " >> ./README.md
echo "![pic](./pic/dingding_pg_chat.png)  " >> ./README.md
echo "  "  >> ./README.md
echo "如有错误, 万望指正, 非常感谢.  "  >> ./README.md
echo "  "  >> ./README.md
echo "欢迎转载(注明出处), 如有问题, 请发issue讨论或微信与我联系, 定抽空尽快回复  " >> ./README.md
echo "  "  >> ./README.md
echo "### 已归类文档如下(归档进行中... ...)  " >> ./README.md
sed 's/](/](class\//g' class/README.md >> ./README.md
echo "### 所有文档如下  " >> ./README.md

for dir in `ls -lr|awk '{print $9}'|grep -E '^[0-9]{6}'` 
do
  cd $dir
  echo "<a rel=\"nofollow\" href=\"http://info.flagcounter.com/h9V1\"  ><img src=\"http://s03.flagcounter.com/count/h9V1/bg_FFFFFF/txt_000000/border_CCCCCC/columns_2/maxflags_12/viewers_0/labels_0/pageviews_0/flags_0/\"  alt=\"Flag Counter\"  border=\"0\"  ></a>  " > ./readme.md
  echo "  " >> ./readme.md
  echo "### 文章列表  "  >> ./readme.md
  echo "----  "  >> ./readme.md
  echo "----  " >> ../README.md
  for file in `ls -lr *.md|awk '{print $9}'|grep -E '^[0-9]{8}'` 
  do 
    title=`head -n 1 $file|awk -F "##" '{print $2}'|sed 's/^[ ]*//; s/[ ]*$//'`
    echo "##### $file   [《$title》]($file)  " >> ./readme.md
    echo "##### $dir/$file   [《$title》]($dir/$file)  " >> ../README.md
    FLAG=`grep "flagcounter" $file|grep -c "href"`
    if [ $FLAG -ne 1 ]; then
      echo "  " >> ./$file
      echo "<a rel=\"nofollow\" href=\"http://info.flagcounter.com/h9V1\"  ><img src=\"http://s03.flagcounter.com/count/h9V1/bg_FFFFFF/txt_000000/border_CCCCCC/columns_2/maxflags_12/viewers_0/labels_0/pageviews_0/flags_0/\"  alt=\"Flag Counter\"  border=\"0\"  ></a>  " >> ./$file
      echo "  " >> ./$file
    fi
# #######################    sed -i '/Count].http:\/\/info.flagcounter.com\/h9V1/d' $file
    LINK=`grep "22709685feb7cab07d30f30387f0a9ae" $file|grep -c "22709685feb7cab07d30f30387f0a9ae"`
    if [ $LINK -ne 1 ]; then
      echo "  " >> ./$file
      echo "## [digoal's 大量PostgreSQL文章入口](https://github.com/digoal/blog/blob/master/README.md \"22709685feb7cab07d30f30387f0a9ae\")" >> ./$file
      echo "  " >> ./$file
    fi
# #######################    sed -i '/22709685feb7cab07d30f30387f0a9ae/d' $file
  done
  cd ..
done

echo "### digoal,德哥的PostgreSQL私房菜, 老文章 : [进入](old_blogs_from_163/README.md)  " >> ./README.md

echo "<a rel=\"nofollow\" href=\"http://info.flagcounter.com/h9V1\"  ><img src=\"http://s03.flagcounter.com/count/h9V1/bg_FFFFFF/txt_000000/border_CCCCCC/columns_2/maxflags_12/viewers_0/labels_0/pageviews_0/flags_0/\"  alt=\"Flag Counter\"  border=\"0\"  ></a>  " >> ./README.md
echo "  " >> ./README.md

cd old_blogs_from_163
. ./generate_readme.sh
cd ..
