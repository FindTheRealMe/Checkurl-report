#!/bin/bash
#Url="members.3322.org/dyndns/getip"
Basedir=$(dirname $(ls `pwd`/$(basename $0)))
source "$Basedir/mediasend.sh"
Debugfile="/tmp/checkurldebug.log"
Time=20
Localmachineip=$(timeout 10 curl -s ident.me)
Url=$1
Retrycount=$2
#use comma delimited,Please input your email list
Userlist='xxxxxxxxx@163.com,123197339@qq.com'
#telegram bot about
Bot_api_key="inplaceofyours"
Chat_id="inplaceofyours"

#function section

function Usage(){
  echo "Please input at least one argument"
  exit 1
}

function Tip(){
  echo "The Argument You Input Is Empty,Use The Default Argument: members.3322.org/dyndns/getip 3"
}

function CheckStatus(){
Url=$1
timeout $Time curl -s $Url 1>/dev/null
return $?
}

function Action(){
Url=$1
retrycount=$2
count=1
index=1

listret=()
while (( "$count <= $retrycount" ))
do 
CheckStatus $Url
retcode=$?
let "count++"
let "index++"
listret[$index]=$retcode
done

if  [[ "${listret[@]}" =~ 0 ]];then
   Writelog  "$(date +%F\ %H:%M:%S) Url: [ $Url ] Check Ok Within $retrycount times Check!" $Debugfile
else
   Writelog  "$(date +%F\ %H:%M:%S) Url: [ $Url ] Check FAILD Within $retrycount times Check!" $Debugfile
   Send_TG_Message   "${Bot_api_key}" "${Chat_id}"  "$(date +%F\ %H:%M:%S) Check Url: \[ $Url ] in machine \[ $Localmachineip ] Within $retrycount times Check  Critical!  In machine \[ $Localmachineip ]  Request Url: \[ $Url ] No Response  Within $retrycount times Check,and The Timeout of Each Time Check Is: $Time Seconds. Or the Url: \[ $Url ] you input is not invalid !" 
fi

}

function Main(){
Url=$1
Retrycount=$2
if [[ $Retrycount != "" ]];then
   Retrycount=$Retrycount
else
   Retrycount=3
fi
if [[ $Url != "" ]];then
   Url=$Url
else
   Url="members.3322.org/dyndns/getip "
fi

if [ $# -lt 1 ];then
  Tip
fi
Action $Url $Retrycount
}

Main $Url $Retrycount
