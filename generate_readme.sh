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
echo "3、[《PostgreSQL 数据库安全指南 - 以及安全合规》](201506/20150601_01.md)    " >> ./README.md
echo "4、[《PostgreSQL 持续稳定使用的小技巧 - 最佳实践、规约、规范》](201902/20190219_02.md)    " >> ./README.md
echo "5、[《PostgreSQL DBA最常用SQL》](202005/20200509_02.md)    " >> ./README.md
echo "6、[《PostgreSQL 数据库开发规范》](201609/20160926_01.md)    " >> ./README.md
echo "7、[《企业数据库选型规则》](197001/20190214_01.md)    " >> ./README.md
echo "8、[《PostgreSQL 规格评估 - 微观、宏观、精准 多视角估算数据库性能(选型、做预算不求人)》](201709/20170921_01.md)    " >> ./README.md
echo "9、[《数据库选型之 - 大象十八摸 - 致 架构师、开发者》](201702/20170209_01.md)    " >> ./README.md
echo "10、[《数据库选型思考(PostgreSQL,MySQL,Oracle)》](201702/20170208_03.md)    " >> ./README.md
echo "11、[《快速入门PostgreSQL应用开发与管理 - 1 如何搭建一套学习、开发PostgreSQL的环境》](201704/20170411_01.md)    " >> ./README.md
echo "12、[《快速入门PostgreSQL应用开发与管理 - 2 Linux基本操作》](201704/20170411_02.md)    " >> ./README.md
echo "13、[《快速入门PostgreSQL应用开发与管理 - 3 访问数据》](201704/20170411_03.md)    " >> ./README.md
echo "14、[《快速入门PostgreSQL应用开发与管理 - 4 高级SQL用法》](201704/20170411_04.md)    " >> ./README.md
echo "15、[《快速入门PostgreSQL应用开发与管理 - 5 数据定义》](201704/20170411_05.md)    " >> ./README.md
echo "16、[《快速入门PostgreSQL应用开发与管理 - 6 事务和锁》](201704/20170412_01.md)    " >> ./README.md
echo "17、[《快速入门PostgreSQL应用开发与管理 - 7 函数、存储过程和触发器》](201704/20170412_02.md)    " >> ./README.md
echo "18、[《快速入门PostgreSQL应用开发与管理 - 8 PostgreSQL 管理》](201704/20170412_04.md)    " >> ./README.md
echo "  "  >> ./README.md
echo "### 三、[感恩](201803/20180322_12.md)  " >> ./README.md
echo "### 四、思想  " >> ./README.md
echo "  "  >> ./README.md
echo "1、[《PostgreSQL 核心卖点提取方法》](202006/20200609_02.md)   " >> ./README.md 
echo "2、[《未来数据库方向》](202005/20200527_06.md)    " >> ./README.md
echo "3、[《企业为什么纷纷选择阿里云AliPG》](202005/20200523_01.md)    " >> ./README.md
echo "4、[《为什么企业应该参与PG社区建设?》](202003/20200321_01.md)    " >> ./README.md
echo "5、[《PostgreSQL 社区建设思考》](202004/20200426_01.md)    " >> ./README.md
echo "6、[《[未完待续] PostgreSQL\Greenplum Customer 社区管理 TODO》](201710/20171017_05.md)    " >> ./README.md
echo "7、[《[未完待续] PostgreSQL\Greenplum Customer视角TODO》](201710/20171017_01.md)    " >> ./README.md
echo "8、[《为什么数据库选型和找对象一样重要》](202003/20200322_01.md)    " >> ./README.md
echo "9、[《云、商业、开源数据库终局之战 - 商业角度解读PG如何破局 - openapi 、 扩展能力、插件开源协议》](202007/20200727_04.md)    " >> ./README.md
echo "10、[《《引爆点》原理, 如何影响PG发展》](197001/20200804_01.md)      " >> ./README.md
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
echo "### 五、已归类文档如下(归档进行中... ...)  " >> ./README.md
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
    title=`head -n 1 ${file}|awk -F "##" '{print $2}'|sed 's/^[ ]*//; s/[ ]*$//'`
    echo "##### ${file}   [《${title}》](${file})  " >> ./readme.md
    echo "##### ${dir}/${file}   [《${title}》](${dir}/${file})  " >> ../README.md
# ######################  go go go
# macos 例子 sed -i "" '/57258f76c37864c6e6d23383d05714ea/d' ${file}
# linux 例子 sed -i '/57258f76c37864c6e6d23383d05714ea/d' ${file}
# ###XYQ###
#sed -i "" '/269ac3d1c492e938c0191101c7238216/d' ${file}
# ###FREEURL###   
#sed -i "" '/57258f76c37864c6e6d23383d05714ea/d' ${file}
# ###ALIPGURL###   
#sed -i "" '/40cff096e9ed7122c512b35d8561d9c8/d' ${file}
# ###LINK###   
#sed -i "" '/22709685feb7cab07d30f30387f0a9ae/d' ${file}
# ###WXLINK###   
#sed -i "" '/f7ad92eeba24523fd47a6e1a0e691b59/d' ${file}
## 
    XYQ=`grep "269ac3d1c492e938c0191101c7238216" ${file}|grep -c "269ac3d1c492e938c0191101c7238216"`
    if [ $XYQ -lt 1 ]; then
      echo "  " >> ./${file}
      echo "#### [PostgreSQL 许愿链接](https://github.com/digoal/blog/issues/76 \"269ac3d1c492e938c0191101c7238216\")" >> ./${file}
      echo "您的愿望将传达给PG kernel hacker、数据库厂商等, 帮助提高数据库产品质量和功能, 说不定下一个PG版本就有您提出的功能点. 针对非常好的提议，奖励限量版PG文化衫、纪念品、贴纸、PG热门书籍等，奖品丰富，快来许愿。[开不开森](https://github.com/digoal/blog/issues/76 \"269ac3d1c492e938c0191101c7238216\").  " >> ./${file}
      echo "  " >> ./${file}
    fi
##
    FREEURL=`grep "57258f76c37864c6e6d23383d05714ea" ${file}|grep -c "57258f76c37864c6e6d23383d05714ea"`
    if [ $FREEURL -ne 1 ]; then
      echo "  " >> ./${file}
      echo "#### [9.9元购买3个月阿里云RDS PostgreSQL实例](https://www.aliyun.com/database/postgresqlactivity \"57258f76c37864c6e6d23383d05714ea\")" >> ./${file}
      echo "  " >> ./${file}
    fi
##
    ALIPGURL=`grep "40cff096e9ed7122c512b35d8561d9c8" ${file}|grep -c "40cff096e9ed7122c512b35d8561d9c8"`
    if [ $ALIPGURL -ne 1 ]; then
      echo "  " >> ./${file}
      echo "#### [PostgreSQL 解决方案集合](https://yq.aliyun.com/topic/118 \"40cff096e9ed7122c512b35d8561d9c8\")" >> ./${file}
      echo "  " >> ./${file}
    fi
## 
    LINK=`grep "22709685feb7cab07d30f30387f0a9ae" $file|grep -c "22709685feb7cab07d30f30387f0a9ae"`
    if [ $LINK -ne 1 ]; then
      echo "  " >> ./$file
      echo "#### [德哥 / digoal's github - 公益是一辈子的事.](https://github.com/digoal/blog/blob/master/README.md \"22709685feb7cab07d30f30387f0a9ae\")" >> ./$file
      echo "  " >> ./$file
    fi
## 
    WXLINK=`grep "f7ad92eeba24523fd47a6e1a0e691b59" $file|grep -c "f7ad92eeba24523fd47a6e1a0e691b59"`
    if [ $WXLINK -ne 1 ]; then
      echo "  " >> ./$file
      echo "![digoal's wechat](../pic/digoal_weixin.jpg \"f7ad92eeba24523fd47a6e1a0e691b59\")" >> ./$file
      echo "  " >> ./$file
    fi
##
#    DSLINK=`grep "acd5cce1a143ef1d6931b1956457bc9f" ${file}|grep -c "acd5cce1a143ef1d6931b1956457bc9f"`
#    if [ $DSLINK -ne 1 ]; then
#      echo "  " >> ./${file}
#      echo "#### 打赏都逃不过老婆的五指山 －_－b  " >> ./$file
#      echo "![wife's weixin ds](../pic/wife_weixin_ds.jpg \"acd5cce1a143ef1d6931b1956457bc9f\")" >> ./$file
#      echo "  " >> ./$file
#    fi
# ######  sed -i '/打赏都逃不过老婆的五指山/d' ${file}
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
