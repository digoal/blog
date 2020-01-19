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
echo "### 一、PostgreSQL, Greenplum 学习视频  " >> ./README.md
echo "  "  >> ./README.md
echo "1、视频下载链接： https://pan.baidu.com/s/1Q5u5NSrb0gL5-psA9DCBUQ   (提取码：5nox   如果链接失效请通知我, 谢谢)  " >> ./README.md
echo "- PostgreSQL 9.3 数据库管理与优化 4天  " >> ./README.md
echo "- PostgreSQL 9.3 数据库管理与优化 5天  " >> ./README.md
echo "- PostgreSQL 9.1 数据库管理与开发 1天  " >> ./README.md
echo "- PostgreSQL 9.3 数据库优化 3天  " >> ./README.md
echo "- PostgreSQL 专题讲座  " >> ./README.md
echo "  "  >> ./README.md
echo "2、[《2020-PostgreSQL+MySQL 联合解决方案课程 - 汇总视频、课件》](202001/20200118_02.md)  " >> ./README.md
echo "3、[《2019-PostgreSQL 2天体系化培训 - 视频每周更新》](201901/20190105_01.md)  " >> ./README.md 
echo "4、[《2017-PostgreSQL 应用场景实践 - 含视频》](201805/20180524_02.md)  " >> ./README.md 
echo "5、[《2019-PG天天象上沙龙纪录- 含视频》](201801/20180121_01.md)  " >> ./README.md 
echo "6、[《2019-Oracle迁移到PostgreSQL - 实战培训》](201906/20190615_03.md)    " >> ./README.md 
echo "7、[《2018-PG生态、案例、开发实践系列 - 培训视频》](https://edu.aliyun.com/course/836/lesson/list)  "  >> ./README.md
echo "8、[《2018-阿里云POLARDB for Oracle|RDS for PPAS 讲解视频》](https://yq.aliyun.com/live/582)  "  >> ./README.md   
echo "  "  >> ./README.md
echo "### 二、学习资料  " >> ./README.md
echo "  "  >> ./README.md
echo "1、[《Oracle DBA 增值 转型 PostgreSQL 学习方法、路径》](201804/20180425_01.md)   " >> ./README.md 
echo "2、[《PostgreSQL、Greenplum 《如来神掌》》](201706/20170601_02.md)    " >> ./README.md
echo "3、[《快速入门PostgreSQL应用开发与管理 - 1 如何搭建一套学习、开发PostgreSQL的环境》](201704/20170411_01.md)    " >> ./README.md
echo "4、[《快速入门PostgreSQL应用开发与管理 - 2 Linux基本操作》](201704/20170411_02.md)    " >> ./README.md
echo "5、[《快速入门PostgreSQL应用开发与管理 - 3 访问数据》](201704/20170411_03.md)    " >> ./README.md
echo "6、[《快速入门PostgreSQL应用开发与管理 - 4 高级SQL用法》](201704/20170411_04.md)    " >> ./README.md
echo "7、[《快速入门PostgreSQL应用开发与管理 - 5 数据定义》](201704/20170411_05.md)    " >> ./README.md
echo "8、[《快速入门PostgreSQL应用开发与管理 - 6 事务和锁》](201704/20170412_01.md)    " >> ./README.md
echo "9、[《快速入门PostgreSQL应用开发与管理 - 7 函数、存储过程和触发器》](201704/20170412_02.md)    " >> ./README.md
echo "10、[《快速入门PostgreSQL应用开发与管理 - 8 PostgreSQL 管理》](201704/20170412_04.md)    " >> ./README.md
echo "  "  >> ./README.md
echo "PG官方微信 | PG技术进阶钉钉群</br>每周直播 | digoal </br>个人微信  " >> ./README.md
echo "---|---|---  " >> ./README.md
echo "![pic](./pic/pg_weixin.jpg) | ![pic](./pic/dingding_pg_chat.jpg) | ![pic](./pic/digoal_weixin.jpg)  " >> ./README.md
echo "  "  >> ./README.md
#echo "PG社区认证 | PG社区认证</br>联系人微信 " >> ./README.md
#echo "---|---  " >> ./README.md
#echo "![pic](./pic/pgcert.jpg) | ![pic](./pic/huhui.jpg)  " >> ./README.md
#echo "  "  >> ./README.md
echo "如发现错误, 请万望指正, 非常感谢.  "  >> ./README.md
echo "  "  >> ./README.md
echo "欢迎转载(注明出处), 如有问题, 请发issue讨论或微信与我联系, 定抽空尽快回复  " >> ./README.md
echo "  "  >> ./README.md
echo "### 三、已归类文档如下(归档进行中... ...)  " >> ./README.md
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
# ######################  go go go
    FREEURL=`grep "57258f76c37864c6e6d23383d05714ea" $file|grep -c "57258f76c37864c6e6d23383d05714ea"`
    if [ $FREEURL -ne 1 ]; then
      echo "  " >> ./$file
      echo "#### [免费领取阿里云RDS PostgreSQL实例、ECS虚拟机](https://www.aliyun.com/database/postgresqlactivity \"57258f76c37864c6e6d23383d05714ea\")" >> ./$file
      echo "  " >> ./$file
    fi
# ######   sed -i '/57258f76c37864c6e6d23383d05714ea/d' $file
    LINK=`grep "22709685feb7cab07d30f30387f0a9ae" $file|grep -c "22709685feb7cab07d30f30387f0a9ae"`
    if [ $LINK -ne 1 ]; then
      echo "  " >> ./$file
      echo "#### [digoal's PostgreSQL文章入口](https://github.com/digoal/blog/blob/master/README.md \"22709685feb7cab07d30f30387f0a9ae\")" >> ./$file
      echo "  " >> ./$file
    fi
# ######   sed -i '/22709685feb7cab07d30f30387f0a9ae/d' $file
    WXLINK=`grep "f7ad92eeba24523fd47a6e1a0e691b59" $file|grep -c "f7ad92eeba24523fd47a6e1a0e691b59"`
    if [ $WXLINK -ne 1 ]; then
      echo "  " >> ./$file
      echo "![digoal's weixin](../pic/digoal_weixin.jpg \"f7ad92eeba24523fd47a6e1a0e691b59\")" >> ./$file
      echo "  " >> ./$file
    fi
# ######   sed -i '/f7ad92eeba24523fd47a6e1a0e691b59/d' $file
#
#    DSLINK=`grep "acd5cce1a143ef1d6931b1956457bc9f" $file|grep -c "acd5cce1a143ef1d6931b1956457bc9f"`
#    if [ $DSLINK -ne 1 ]; then
#      echo "  " >> ./$file
#      echo "#### 打赏都逃不过老婆的五指山 －_－b  " >> ./$file
#      echo "![wife's weixin ds](../pic/wife_weixin_ds.jpg \"acd5cce1a143ef1d6931b1956457bc9f\")" >> ./$file
#      echo "  " >> ./$file
#    fi
# ######  sed -i '/打赏都逃不过老婆的五指山/d' $file
# ######  sed -i '/acd5cce1a143ef1d6931b1956457bc9f/d' $file
#
#    FLAG=`grep "flagcounter" $file|grep -c "href"`
#    if [ $FLAG -ne 1 ]; then
#      echo "  " >> ./$file
#      echo "<a rel=\"nofollow\" href=\"http://info.flagcounter.com/h9V1\"  ><img src=\"http://s03.flagcounter.com/count/h9V1/bg_FFFFFF/txt_000000/border_CCCCCC/columns_2/maxflags_12/viewers_0/labels_0/pageviews_0/flags_0/\"  alt=\"Flag Counter\"  border=\"0\"  ></a>  " >> ./$file
#      echo "  " >> ./$file
#    fi
# ######   sed -i '/href=\"http:\/\/info.flagcounter.com\/h9V1/d' $file
  done
  cd ..
done

echo "### digoal,德哥的PostgreSQL私房菜, 老文章 : [进入](old_blogs_from_163/README.md)  " >> ./README.md

echo "<a rel=\"nofollow\" href=\"http://info.flagcounter.com/h9V1\"  ><img src=\"http://s03.flagcounter.com/count/h9V1/bg_FFFFFF/txt_000000/border_CCCCCC/columns_2/maxflags_12/viewers_0/labels_0/pageviews_0/flags_0/\"  alt=\"Flag Counter\"  border=\"0\"  ></a>  " >> ./README.md
echo "  " >> ./README.md

cd old_blogs_from_163
. ./generate_readme.sh
cd ..
