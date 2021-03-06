#!/usr/bin/python

import os
import commands
import datetime
import sys
import getopt
import smtplib
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email import Encoders
from optparse import OptionParser

def sendReport(sender,receivers, text, mailSubject, op):
    msgRoot = MIMEMultipart()
    msgRoot["Accept-Charset"] = "ISO-8859-1,GBK,utf-8"
    msgRoot["Accept-Language"] = "zh-CN"
    msgRoot['Subject'] = mailSubject
    msgRoot['From'] = sender
    listRecv = receivers.split(",");
    msgRoot['To'] = ", ".join(listRecv);
    #print sender
    msgRoot.attach(MIMEText(text,_subtype='html',_charset='utf-8'))

    # Send the message via our own SMTP server, but don't include the
    # envelope header.
    if op.isssl == 1 :
        s = smtplib.SMTP()
        #Uncomment the below to debug
        #s.set_debuglevel(1)
        try:
            s.connect(op.server,op.port)
        except Exception, e:
            print e, 'connect failed ...'
            return False
        s.starttls()
    else:
        s = smtplib.SMTP(op.server,op.port)
    #-------replace-----------
    s.login("xxxxxxxx@gmail.com","xxxxxxxxxxxxxxxx");
    s.sendmail(sender, listRecv, msgRoot.as_string())
    s.quit()

def read_mail_body_file(filename):
    file_object = open(filename)
    all_line = file_object.read()
    file_object.close()
    return all_line

def read_mail_receiver_list_file(filename):
    file_object = open(filename)
    all_line = file_object.readlines()
    file_object.close()
    receiver_list = []
    for receiver in all_line:
        receiver_list.append(receiver.strip().strip('\r').strip('\n'))
    return receiver_list

if __name__ == "__main__":
    usage_str = "usage: %prog [options] send-mail-content-file"
    version_str = "%prog 1.0.0"
    parser = OptionParser(usage=usage_str, version=version_str)
    #If you use the general qq email,use this:
    parser.add_option("", "--smtp", dest="server", default="smtp.gmail.com",
    #If you use the Enterprise qq email ,please use the commented mail address below
    #parser.add_option("", "--smtp", dest="server", default="smtp.exmail.qq.com",
                      help="smtp server ip", type="string")
    parser.add_option("", "--port", dest="port", default=25,
                      help="smtp server port", type="int")
    parser.add_option("", "--ssl", dest="isssl", default=1,
                      help="is using ssl", type="int")
    #replace-----------------
    parser.add_option("-f", "--from", dest="sender", default="xxxguest@gmail.com",
                      help="mail from user", type="string")
    parser.add_option("-s", "--subject", dest="subject", default="test",
                      help="mail subject", type="string")
    parser.add_option("-t", "--to", dest="to", default="",
                      help="mail to list, comma seperate", type="string")
    (op, args) = parser.parse_args()
    nargs = len(args)
    if nargs != 1:
        parser.error("incorrect number of arguments. See %prog --help")
        sys.exit(1)
    sendReport(op.sender,op.to,read_mail_body_file(args[0]),op.subject,op)
