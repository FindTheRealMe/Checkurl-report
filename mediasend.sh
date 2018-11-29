function Writelog(){
     Message=$1
     Logfile=$2
     echo "$Message" >> $Logfile 
}

function Send_TG_Message(){
     Bot_api_key="$1"
     Chatid="$2"
     Message="$3"
     [ $# -ne 3 ] && echo "Please input three args [ Bot_api_key Chatid Message ]"
     Logfile="/tmp/sendmessagedebug.log"
     Datetime=`date +%F\ %H:%M:%S`
     Execresult=`curl -sg "https://api.telegram.org/bot${Bot_api_key}/sendMessage?text=${Message}&chat_id=${Chat_id}&parse_mode=Markdown"`
     Okstatus=`echo $Execresult|grep -c '"ok":true' `
     retcode=$?
     if [ $retcode -eq 0 ] && [ $Okstatus -ge 1 ] ;then
     	 Writelog  "${Datetime} Send Telegram Message Successfully!" $Logfile 
     else
        Writelog   "${Datetime} Send Telegram Message Failed!" $Logfile	
     fi

}

function Sendmail(){
to=$1
subject=$2
body=$3
pyscriptspath=$(dirname $(ls `pwd`/`basename $0`))
cd $pyscriptspath
mailfile="mailinfo.debug"
echo -e "$body" > $mailfile
python sendmail.py -t $to -s "$subject"  "$mailfile" >> $Debugfile
rm -f $mailfile
}
