#!/bin/sh
# 阿里云开启ipv6

# 1. 修改/etc/modprobe.d/disable_ipv6.conf
if [ ! -f "/etc/modprobe.d/disable_ipv6.conf_backup" ]; then
    cp /etc/modprobe.d/disable_ipv6.conf /etc/modprobe.d/disable_ipv6.conf_backup 
    sed -i "s/ipv6 disable=1/ipv6 disable=0/g" /etc/modprobe.d/disable_ipv6.conf
fi

# 2. 修改/etc/sysconfig/network
if [ ! -f "/etc/sysconfig/network_backup" ]; then
    cp /etc/sysconfig/network /etc/sysconfig/network_backup
    sed -i "s/NETWORKING_IPV6=no/NETWORKING_IPV6=yes/g" /etc/sysconfig/network
fi

# 3. 修改/etc/sysconfig/network-scripts/ifcfg-eth0
if [ ! -f "/etc/sysconfig/network-scripts/ifcfg-eth0_backup" ]; then
    cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0_backup
    echo 'IPV6INIT=yes' >>/etc/sysconfig/network-scripts/ifcfg-eth0
    echo 'IPV6_AUTOCONF=yes' >>/etc/sysconfig/network-scripts/ifcfg-eth0
fi

# 4. 修改/etc/sysctl.conf
if [ ! -f "/etc/sysctl.conf_backup" ]; then
    cp /etc/sysctl.conf /etc/sysctl.conf_backup
    sed -i "s/disable_ipv6 = 1/disable_ipv6 = 0/g" /etc/sysctl.conf
fi

# 5. 修改/etc/sysconfig/modules/ipv6.modules
tee /etc/sysconfig/modules/ipv6.modules <<-'EOF'
#!/bin/sh
if [ ! -c /proc/net/if_inet6 ] ; then
    exec /sbin/insmod /lib/modules/uname -r/kernel/net/ipv6/ipv6.ko
fi
EOF

# 6. 修改/etc/sysctl.conf
if [ ! -f "/etc/init.d/network_backup" ]; then
    cp /etc/init.d/network /etc/init.d/network_backup
    line=`cat -n /etc/init.d/network | grep "touch /var/lock/subsys/network" | awk '{print $1}'`
    sed -i $line'i \
    ifconfig sit0 up\
    ifconfig sit0 inet6 tunnel ::216.218.221.6\
    ifconfig sit1 up\
    ifconfig sit1 inet6 add 2001:470:18:cab::2/64\
    route -A inet6 add ::/0 dev sit1\
' /etc/init.d/network
fi