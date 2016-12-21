#瀏覽器和msn在socks 5 proxy設定的欄位填上localhost:9999 
#連出去的連驗就是加密，並且是穿過remote_ip的連線。
#-N : 不執行任何命令
#-f : 在背景執行
#-D : 建socks5 的proxy
alias ssh -ND 9999 remote_ip

#telnet localhost 2323 就可以連到巴哈，而且是加密的。
#也可用PCManx連localhost 2323也是一樣的意思。
ssh -NfL 2323:bbs.gamer.com.tw:23 remote_ip
#-L : 將local port 轉向

#有時候假日，想要連回公司加個班。
#但是公司是NAT，所以沒辦法這樣作。
#可以運用TCP雙向傳輸的特性來辦到這件事。
ssh -NfR 2222:localhost:22 remote_ip
#-R : 將remote port轉向
#這時候，只要跑到remote_ip的機器上面
ssh localhost -p 2222
#就會跑到在NAT後面，公司的機器。
#簡單說就是開後門啦！
