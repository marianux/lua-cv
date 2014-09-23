
set DEFAULT_GW = 10.211.1.2
set TUN_ID = {CE37B83D-0E0D-4B83-B3E5-EBE5F6774028}
route delete 0.0.0.0 %DEFAULT_GW% 
netsh interface ip delete arpcache
C:\Windows\SysWOW64\ForceBindIP.exe %TUN_ID% "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
