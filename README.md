### Hi there 👋

```shell
#!/bin/csh

# 声明并初始化变量
set satellite_dir="/Users/showen/Documents/cyy/shell/csh/pdf"
set log_dir="/Users/showen/Documents/cyy/shell/csh/log"
set warning_file="/Users/showen/Documents/cyy/shell/csh/warning.csv"
set normal_count=0
set warning_count=0

# 输出日志函数
alias log_output 'echo \!:1 >> $log_dir/log'

# 输出开始处理的日志
log_output "C:BGJ62058:PDF处理开始"

# 判断 satellite_dir路径是否存在
if (! -e $satellite_dir) then
    log_output "F:BGJ62068:异常终了"
    exit 100
endif

# 清空删除失败记录的 csv 文件
rm -f $warning_file

# 检查文件夹是否为空
set file_count = `ls -1 $satellite_dir | wc -l`
if ($file_count) then
    # 遍历目标文件夹下的文件
    foreach file ($satellite_dir/*)
        # 删除文件
        rm "$file"
        if ($status == 0) then
            @ normal_count++
        else
            @ warning_count++
            echo "$file" >> $warning_file
        endif
    end
endif

# 统计处理结果
log_output "C:正常处理：$normal_count 件"
log_output "C:警告处理：$warning_count 件"

# 根据警告处理的数量确定退出状态码
if ($warning_count) then
    exit 1
else
    exit 0
endif

```