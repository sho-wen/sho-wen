### Hi there 👋

```shell
#!/bin/bash

# 读取CSV文件
filename="/Users/showen/Documents/cyy/shell/csv/folderInfo.csv"

# 声明数组
fullName=()
name=()
fileLength=()
extension=()
creationTime=()
lastWriteTime=()

# 判断文件是否存在
if [ ! -f "$filename" ]; then
  echo "文件不存在: $filename"
  exit 1
fi

# 使用awk命令逐行读取并提取各个字段，输出name和fileLength字段到标准输出
list_output=$(awk -F',' 'NR>0 {
    gsub(/"/, "", $1); fullName[NR-1]=$1;
    gsub(/"/, "", $2); name[NR-1]=$2;
    gsub(/"/, "", $3); fileLength[NR-1]=$3;
    gsub(/"/, "", $4); extension[NR-1]=$4;
    gsub(/"/, "", $5); creationTime[NR-1]=$5;
    gsub(/"/, "", $6); lastWriteTime[NR-1]=$6;
} END {
    for (i=0; i<length(name); i++) {
        mergedArray[i] = name[i];
    }
    for (i=0; i<length(fileLength); i++) {
        mergedArray[length(name)+i] = fileLength[i];
    }
    for (i=0; i<length(mergedArray); i++) {
        printf "%s ", mergedArray[i];
    }
    printf "\n";
}' "$filename")

# 捕获AWK输出打印到控制台
echo "=> $list_output"

# Linux 服务器的地址和登录用户名密码
SERVER="10.XXX.XX.X"
FTP_USERNAME="XXX"
FTP_PASSWORD="XXX"

# 打印日志
echo "从 FTP 服务器：$SERVER => ファイル取得。"

# 远程文件夹路径
REMOTE_DIR="/home/parallels/Documents"

# 本地文件夹路径
LOCAL_DIR="/Users/showen/Documents/cyy/shell/local_file"

# 连接到 FTP 服务器并下载文件
ftp -n "$SERVER" <<EOF
    quote USER "$FTP_USERNAME"
    quote PASS "$FTP_PASSWORD"
    binary
    passive off
    cd "$REMOTE_DIR"
    lcd "$LOCAL_DIR"
    prompt off
    mget *
    quit
EOF

# 筛选和删除不在 list_output 中的文件
for file in "$LOCAL_DIR"/*; do
    filename=$(basename "$file")
    if [[ $list_output != *"$filename"* ]]; then
        echo "删除文件: $filename"
        rm "$file"
    fi
done

# 打印日志
echo "从 FTP 服务器：$SERVER => ファイル取得完了しました。"
```