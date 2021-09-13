# BiliFavoritesDownloader

## 注意

此脚本为自用脚本，不保证其他机子能正常运行

## 功能

- [x] 最高清晰度下载（需要大会员）
- [x] 邮件通知
- [x] 封面图下载
- [x] xml 转 ass
- [x] 下载完成上传 OneDrive
- [ ] 一键脚本完成初始化设置
- [ ] 初次使用下载收藏夹以前的所有视频

## 使用

脚本原理是每分钟检查 RSS，然后通过 you-get 进行下载

脚本中注释已经写的很明白了，必须要修改的是```RSS地址```和```邮箱地址```，可选修改地址为```脚本及标记文件存放地址```和```视频存储地址```

默认```脚本及标记文件存放地址```为```/root/bili```
默认```视频存储地址```为```/root/Bilibili```

最高画质下载需要设置```cookies.txt```，默认存放在```/root/bili```

Chrome 可以安装 [EditThisCookie](https://chrome.google.com/webstore/detail/editthiscookie/fngmhnnpilhplaeedifhccceomclgfbg) 插件，将```导出格式```设置为```Netscape HTTP Cookies File```然后导出粘贴在```cookies.txt```中即可

xml转ass使用的是[DanmakuFactory](https://github.com/hihkm/DanmakuFactory)，这里提供了已编译好的可执行文件，同样是默认存放在```/root/bili```下

OneDrive 使用的是[rclone](https://github.com/rclone/rclone)，需要自行配置

百度云 使用的是[BaiduPCS-Go](https://github.com/qjfoidnh/BaiduPCS-Go)，需要自行配置

配置完成后设置```crontab```即可使用

```shell
*/1 * * * * /bin/bash /root/bili/bili.sh >/dev/null 2>&1
```

## 效果

点击某一视频的收藏后开始下载

![点击收藏](https://raw.githubusercontent.com/Left024/images/main/picgo20210913230146.png)

![开始下载](https://raw.githubusercontent.com/Left024/images/main/picgo20210913225853.png)

下载完成后通知

![下载完成](https://raw.githubusercontent.com/Left024/images/main/picgo20210913225948.png)

下载完成后的文件目录

![文件目录](https://raw.githubusercontent.com/Left024/images/main/picgo20210913230035.png)

## 感谢

[you-get](https://github.com/soimort/you-get)

[DanmakuFactory](https://github.com/hihkm/DanmakuFactory)

[rclone](https://github.com/rclone/rclone)

[BaiduPCS-Go](https://github.com/qjfoidnh/BaiduPCS-Go)

[RSShub](https://github.com/DIYgod/RSSHub)
