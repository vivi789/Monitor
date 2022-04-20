#!/bin/bash
blacklist="
0spam.fusionzero.com
access.redhawk.org
all.s5h.net
all.spamrats.com
aspews.ext.sorbs.net
babl.rbl.webiron.net
backscatter.spameatingmonkey.net
b.barracudacentral.org
bb.barracudacentral.org
black.junkemailfilter.com
bl.blocklist.de
bl.drmx.org
bl.konstant.no
bl.mailspike.net
bl.nosolicitado.org
bl.nszones.com
block.dnsbl.sorbs.net
bl.rbl.scrolloutf1.com
bl.scientificspam.net
bl.score.senderscore.com
bl.spamcop.net
bl.spameatingmonkey.net
bl.suomispam.net
bsb.empty.us
cart00ney.surriel.com
cbl.abuseat.org
cbl.anti-spam.org.cn
cblless.anti-spam.org.cn
cblplus.anti-spam.org.cn
cdl.anti-spam.org.cn
combined.rbl.msrbl.net
db.wpbl.info
dnsbl-1.uceprotect.net
dnsbl-2.uceprotect.net
dnsbl-3.uceprotect.net
dnsbl.cobion.com
dnsbl.dronebl.org
dnsbl.justspam.org
dnsbl.kempt.net
dnsbl.net.ua
dnsbl.rv-soft.info
dnsbl.rymsho.ru
dnsbl.sorbs.net
dnsbl.spfbl.net
dnsbl.tornevall.org
dnsbl.zapbl.net
dnsrbl.org
dnsrbl.swinog.ch
dul.dnsbl.sorbs.net
dyna.spamrats.com
dyn.nszones.com
escalations.dnsbl.sorbs.net
fnrbl.fast.net
hostkarma.junkemailfilter.com
http.dnsbl.sorbs.net
images.rbl.msrbl.net
invaluement
ips.backscatterer.org
ix.dnsbl.manitu.net
l1.bbfh.ext.sorbs.net
l2.bbfh.ext.sorbs.net
l4.bbfh.ext.sorbs.net
list.bbfh.org
mail-abuse.blacklist.jippg.org
misc.dnsbl.sorbs.net
multi.surbl.org
netscan.rbl.blockedservers.com
new.spam.dnsbl.sorbs.net
noptr.spamrats.com
old.spam.dnsbl.sorbs.net
pbl.spamhaus.org
phishing.rbl.msrbl.net
pofon.foobar.hu
problems.dnsbl.sorbs.net
proxies.dnsbl.sorbs.net
psbl.surriel.com
rbl2.triumf.ca
rbl.abuse.ro
rbl.blockedservers.com
rbl.dns-servicios.com
rbl.efnet.org
rbl.efnetrbl.org
rbl.interserver.net
rbl.megarbl.net
rbl.realtimeblacklist.com
recent.spam.dnsbl.sorbs.net
relays.dnsbl.sorbs.net
rep.mailspike.net
safe.dnsbl.sorbs.net
sbl.spamhaus.org
smtp.dnsbl.sorbs.net
socks.dnsbl.sorbs.net
spam.dnsbl.anonmails.de
spam.dnsbl.sorbs.net
spamlist.or.kr
spam.pedantic.org
spam.rbl.blockedservers.com
spamrbl.imp.ch
spam.rbl.msrbl.net
spamsources.fabel.dk
spam.spamrats.com
srn.surgate.net
stabl.rbl.webiron.net
st.technovision.dk
talosintelligence.com
torexit.dan.me.uk
truncate.gbudb.net
ubl.unsubscore.com
virus.rbl.msrbl.net
web.dnsbl.sorbs.net
web.rbl.msrbl.net
xbl.spamhaus.org
zen.spamhaus.org
z.mailspike.net
zombie.dnsbl.sorbs.net
"
tmp=`mktemp`
ip=`ip a | grep inet | grep -Ev "inet6|127.0.0.1" | awk  {'print $2'} | cut -d "/" -f 1`

for i in $blacklist
do
        for j in $ip
        do
                echo $j
                reverse=`echo $j | awk -F. '{print $4"."$3"." $2"."$1}'`
                result=`host $reverse.$i`
                if [[ $result == *"127"* ]]
                then
                        echo "$i [LISTED]"
                        echo "$j $i [LISTED]" >> $tmp
                else
                        echo "$j $i [OK]"
                fi
        done
done

# send email
if [ -s test.txt ]
then
        sort $tmp | mail -s "[$(hostname)] Check Blacklist IPs" support.team@vinahost.vn
fi
rm -f $tmp
