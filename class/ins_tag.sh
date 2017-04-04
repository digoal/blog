# 给文件贴标签
# 注意, 不要修改归档目录中的归档md的文件名, 因为要用它

# 1. fixpath , 修正*.md中的file路径
. ./1_fix_path.sh

# 2. 遍历归类md文件内容, 将标签贴到源文件第二行, 格式##### [TAG *], tag=归档文件名中的数字
for file in `ls [0-9]*.md`
do 
  # TAG=归档文件名中的数字, 不要修改文件名
  TAG=`echo "$file"|awk -F '.' '{print $1}'`
  for md in `cat $file |grep ".md"|awk -F '[' '{print $1}'|awk '{print "../"$2}'`
  do
    # 查找是否已标记TAG
    CNT=`head -n 10 $md | grep -c "##### \[TAG"`
    if [ $CNT -eq 0 ]; then
      # echo "未标记 $TAG $md"
      # 未标记, 则在第一行下面插入TAG
      sed -i "1 a ##### [TAG ${TAG}](../class/${TAG}.md)" $md
    else
      # 已标记, 检查是否已贴上当前TAG
      CNT=`head -n 10 $md | grep -c "\[TAG ${TAG}\]"`
      if [ $CNT -lt 1 ]; then
        # echo "已标记,追加 $TAG $md"
        sed -i "0,/##### \[TAG/{s/##### \[TAG.*\($\)/\0 , [TAG ${TAG}](..\/class\/${TAG}.md)/}" $md
      else
        echo "已标记 $TAG $md, 无需追加"
      fi
    fi
  done
done

# 3. 将源文件中已有TAG合并到归类.md文件
for file in `ls [0-9]*.md`
do 
  # TAG=归档文件名中的数字, 不要修改文件名
  TAG=`echo "$file"|awk -F '.' '{print $1}'`
  # 遍历所有源文件
  for dir in `ls -lr ../|awk '{print $9}'|grep -E '^[0-9]{6}'` 
  do
    for md in `ls -lr ../$dir/*.md|awk '{print $9}'|grep -E '[0-9]{8}_[0-9]+.md'` 
    do
      # 查找是否已标记当前TAG
      CNT=`head -n 3 $md | grep -c "\[TAG ${TAG}\]"`
      if [ $CNT -ge 1 ]; then
        # 已标记当前TAG, 查询是否已合并到归档md
        CNT=`grep -c "$md" $file`
        if [ $CNT -lt 1 ]; then
          title=`head -n 1 $md|awk -F "##" '{print $2}'|sed 's/^[ ]*//; s/[ ]*$//'`
	  s_md=`echo "$md"|sed "s/..\///"`
	  sed -i "1 a ##### $s_md   [《$title》]($md)  " $file
	fi
      fi
    done
  done
done

# 4. 排序, 去重
for file in `ls [0-9]*.md`
do 
  cat $file | sort -k 2 -n | uniq > ./sort.tmp
  cat ./sort.tmp > ./$file
done
