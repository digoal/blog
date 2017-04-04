# 1. fixpath , 修正*.md中的file路径
. ./1_fix_path.sh

# 2. 遍历归类md文件内容, 将标签贴到源文件第二行, 格式##### [TAG *], tag=归档文件名中的数字
for file in `ls [0-9]*.md`
do 
  # TAG=归档文件名中的数字, 不要修改文件名
  TAG=`echo "$file"|awk -F '.' '{print $1}'`
  # 查找是否已标记TAG
  for md in `cat $file |grep ".md"|awk -F '[' '{print $1}'|awk '{print "../"$2}'`
  do
    # 查找是否已标记TAG
    CNT=`head -n 10 $md | grep -c "##### \[TAG"`
    if [ $CNT -eq 0 ]; then
      # 未标记, 在第一行下面插入TAG
      sed -i "1 a ##### [TAG ${TAG}]" $md
    else
      # 已标记, 检查是否已贴上当前TAG
      CNT=`head -n 10 $md | grep -c "\[TAG ${TAG}\]"`
      # 追加到行尾
      if [ $CNT -lt 1 ]; then
        sed -i "0,/##### \[TAG/ s/##### \[TAG.*\($\)/\0 [TAG ${TAG}]/" $md
      fi
    fi
  done
done
