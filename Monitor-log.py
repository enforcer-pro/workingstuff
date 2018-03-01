#!/usr/bin/env python
#-*-coding:utf-8-*-
#CreateDate:2017/04/14
#Author:Eivll0m
#ScriptName:monitor-log.py
#Crontab:*/5 * * * * /app/sbin/monitor-log.py &>/dev/null


import os
import time
import stat
import socket
import smtplib
from email.mime.text import MIMEText
#from email.mime.multipart import MIMEMultipart
from email.header import Header
from email.utils import parseaddr, formataddr

def formatAddr(s):
    name, addr = parseaddr(s)
    return formataddr((Header(name, 'utf-8').encode(), addr))
def sendMail(body,subject):
    smtp_server = 'smtp.exmail.qq.com'
    from_mail = 'xxx@xxxx.com'
    mail_pass = 'password'
    to_mail = ['aaa@xxx.com','bbb@xxx.com','ccc@xxx.com']
    cc_mail = ['ddd@xxx.com','eee@xxx.com','fff@xxx.com','ggg@xxx.com','hhh@xxx.com']
    msg = MIMEText(body,'html','utf-8')
    msg['From'] = formatAddr('日志监控 <%s>' % from_mail).encode()
    msg['To'] = ','.join(to_mail)
    msg['Cc'] = ','.join(cc_mail)
    msg['Subject'] = Header(subject, 'utf-8').encode()
    try:
        s = smtplib.SMTP()
        s.connect(smtp_server, "25")
        s.login(from_mail, mail_pass)
        s.sendmail(from_mail, to_mail+cc_mail, msg.as_string())
        s.quit()
    except smtplib.SMTPException as e:
        print("Error: %s" % e) 


def GetText(file):
    cmd = "awk -vf='%s' 'BEGIN{while(getline < f){j++;if(/ERROR/)i=j}}NR>=i' %s" %(file,file)
    text = os.popen(cmd).readlines()
    return ''.join(text)


def CheckFileStat(file):
    FileStats = os.stat(file)
    ModifyTime = time.mktime(time.strptime(time.ctime(FileStats[stat.ST_MTIME]),"%a %b %d %H:%M:%S %Y")) + 300
    LocalTime = time.time()
    if LocalTime < ModifyTime:
        return True
    else:
        return False

if __name__ == "__main__":
    logs = ['/app/log/channelmanage/channelerror.log','/app/log/assetmanage/error.log']
    LocalIP = socket.gethostbyname(socket.gethostname())
    for log in logs:
        if CheckFileStat(log):
            sj = log.split('/')[5] + ' 错误日志 ' + '[主机IP:' + LocalIP + ']'
            body = GetText(log)
            sendMail(body, sj)
