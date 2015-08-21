#
# faildns.ps1
#

netsh advfirewall firewall add rule name="chaos_monkey_dnsblock_tcp" protocol=tcp dir=out remoteport=53 action=block
netsh advfirewall firewall add rule name="chaos_monkey_dnsblock_udp" protocol=udp dir=out remoteport=53 action=block