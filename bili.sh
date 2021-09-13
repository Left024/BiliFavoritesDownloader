#!/bin/bash
you=/usr/local/bin/you-get
#RSS地址自行修改
content=$(wget rss地址 -q -O -)
#获得时间戳
subpubdate=${content#*<pubDate>}
pubdate=${subpubdate%%</pubDate>*}
#获得视频标题
content1=${content#*<item>}
subname=${content1#*\[CDATA\[}
name=${subname%%\]\]>*}
#如果时间戳记录文本不存在则创建（此处文件地址自行修改）
if [ ! -f "/root/bili/date.txt" ];then
    echo 313340 > /root/bili/date.txt
fi
#如果标题记录文本不存在则创建
if [ ! -f "/root/bili/title.txt" ];then
    echo 313340 > /root/bili/title.txt
fi
#获得之前下载过的视频标题
oldtitle=$(cat /root/bili/title.txt)
#获得上一个视频的时间戳（文件地址自行修改）
olddate=$(cat /root/bili/date.txt)
#此处为视频存储位置，自行修改
filename="/root/Bilibili/"$name""
#aaaaa="GMT"
result=$(echo $pubdate | grep "GMT")
result5=$(echo $oldtitle | grep "$name")
#echo $result
#判断当前时间戳和上次记录是否相同，不同则代表收藏列表更新
if [ "$pubdate" != "$olddate" ] && [ "$result" != "" ] && [ "$result5" = "" ];then
    #清空 Bilibili 文件夹
    rm -rf /root/Bilibili/*
    #获得视频下载链接
    sublink=${subpubdate#*<link>}
    link=${sublink%%</link>*}
    av=${link#*video/}
    #获得封面图下载链接和文件名称
    subcontent=${content#*<img src=\"}
    photolink=${subcontent%%\"*}
    pname=${photolink#*archive/}
    #下载封面图（图片存储位置应和视频一致）
    wget -P /root/Bilibili/"$name" $photolink
    #记录时间戳
    echo $pubdate > /root/bili/date.txt
    #记录标题
    echo $name >> /root/bili/title.txt
    #获取视频清晰度以及大小信息
    stat=$($you -i -l -c /root/cookies.txt $link)
    #有几P视频
    count=$(echo $stat | awk -F'title' '{print NF-1}')
    #echo $count
    for((i=0;i<$count;i++));
    do
        stat=${stat#*title:}
        title=${stat%%streams:*}
        substat=${stat#*quality:}
        data=${substat%%#*}
        quality=${data%%size*}
        size=${data#*size:}
        title=`echo $title`
        quality=`echo $quality`
        size=`echo $size`
        #每一P的视频标题，清晰度，大小，发邮件用于检查下载是否正确进行
        message=${message}"Title: "${title}$'\n'"Quality: "${quality}$'\n'"Size: "${size}$'\n\n'
    done
    #发送开始下载邮件（自行修改邮件地址）
    echo "$message" | mail -s "BFD：开始下载" email@example.com
    #下载视频到指定位置（视频存储位置自行修改）
    count=1
	while true
        do
        $you -l -c /root/cookies.txt -o /root/Bilibili/"$name" $link
        if [ $? -eq 0 ]; then
            #下载完成
            #重命名封面图
            result1=$(echo $pname | grep "jpg")
            if [ "$result1" != "" ];then
                mv /root/Bilibili/"$name"/$pname /root/Bilibili/"$name"/poster.jpg
            else
                mv /root/Bilibili/"$name"/$pname /root/Bilibili/"$name"/poster.png
            fi
            #xml转ass && 获取下载完的视频文件信息
            for file in /root/Bilibili/"$name"/*
            do
                if [ "${file##*.}" = "xml" ]
                then
                    /root/bili/DanmakuFactory -o "${file%%.cmt.xml*}".ass -i "$file"
                    #删除源文件
                    #rm "$file"
                elif [ "${file##*.}" = "mp4" ] || [ "${file##*.}" = "flv" ] || [ "${file##*.}" = "mkv" ];
                then
                    videoname=${file#*"$name"\/}
                    videostat=$(du -h "$file")
                    videosize=${videostat%%\/*}
                    videomessage=${videomessage}"Title: "${videoname}$'\n'"Size: "${videosize}$'\n\n'
                fi
            done
            #发送下载完成邮件
            echo "$videomessage" | mail -s "BFD：下载完成" email@example.com
            #上传至OneDrive 百度云
            /usr/bin/rclone copy /root/Bilibili OneDrive:1tb/Bilibili
            /usr/local/bin/BaiduPCS-Go upload /root/Bilibili /
            echo "$title" | mail -s "BFD：上传完成" email@example.com
            break;
        else
            if [ "$count" != "10" ];then
                count=$(($count+1))
                sleep 2
            else
                rm -rf /root/Bilibili/"$name"
                echo "$name" | mail -s "BFD：下载失败" email@example.com
                exit
            fi
        fi
    done
fi