# 删除源文件标签
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
      # 未标记
      echo "$md $TAG 未标记"
    else
      echo "$md $TAG 删除标记"
      # 已标记, 清除标记
      sed -i "0,/##### \[TAG/{/##### \[TAG/d}" $md
    fi
  done
done
