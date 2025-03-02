#!/system/bin/sh

# 获取指定应用uid
get_uid_by_package() {
local package_name=$1
uid=$(cat /data/system/packages.list | grep "$package_name" | awk '{print $2}')
echo "$uid"
}

# 屏蔽ip
iptables_ip() {
iptables -A OUTPUT -d "$1" -m owner --uid-owner $uid -j REJECT
}

# 屏蔽域名
iptables_domain() {
iptables -A OUTPUT -m string --string "$1" --algo bm -m owner --uid-owner $uid -j REJECT
}

# 屏蔽端口
iptables_port() {
iptables -A OUTPUT -p tcp --dport "$1" -m owner --uid-owner $uid -j REJECT
}


main () {
iptables=/system/bin/iptables

# 先清空所有规则 
# 清除所有iptables规则
iptables -F
iptables -X
iptables -Z

uid=$(get_uid_by_package "com.tencent.af")

if [[ -z "$uid" ]]; then
echo "包名 '$package_name' 不存在或未安装"
exit
fi


# 拦截域名
# 下载的反作弊资源
# https://down.anticheatexpert.com/iedsafe/Client/android/2135/config2.xml
# https://down.anticheatexpert.com/iedsafe/Client/android/2135/config3.xml
# https://down.anticheatexpert.com/iedsafe/Client/android/2135/9DED575B/ob_cs2.zip
# https://down.anticheatexpert.com/iedsafe/Client/android/2135/4AAA0499/comm.zip
# https://down.anticheatexpert.com/iedsafe/Client/android/2135/02EEF505/mrpcs_com.data
# https://down.anticheatexpert.com/iedsafe/Client/android/2135/8C6059D2/tssmua.zip
# https://down.anticheatexpert.com/iedsafe/Client/android/2135/E05CFEE9/mrpcs.data
# 2135=08 57
iptables_domain "anticheatexpert.com"
# iptables_domain "h.trace.qq.com"


# 拦截ip
# http://182.254.116.117/d?dn=0f70018490b04750163dd6d6a71740a0&clientip=1&ttl=1&id=1&token=-1
# dn参数=设备信息相关
iptables_ip "182.254.116.117"

# 拦截端口
iptables_port "10012"

echo "com.tencent.af"
echo "uid $uid"
echo "正义使者内部定制"
echo "拦截开启成功"

# log输出到文件
# iptables -S >./iptables.txt

}


main

