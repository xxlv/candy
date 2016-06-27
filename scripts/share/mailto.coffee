# Description:
#  Virtual Station 项目助手
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# @vs flush  - 刷新时间戳
# @vs flush online - 刷新线上时间戳
# @vs publish a new version <!> - 预览一个新版本, !将触发上线
# Author:
#   x

config=require '../config'
# 邮件相关配置
MAIL_USER=config.MAIL_USER
MAIL_PASS=config.MAIL_PASS

# resport send status
_report_staus=(error,info)->
    if error
        console.log("发送邮件失败！"+ error)
    else
        console.log info



# send mail
sendmail=(to,subject,html)->
    nodemailer=require "nodemailer"

    from=MAIL_USER
    cc=[]
    user=MAIL_USER
    pass=MAIL_PASS
    body=''
    subject=subject


    mailoptions=
        from:from,
        to:to,
        cc:cc,
        subject:subject,
        text:body,
        html:html
        
    simpleconfig=
        host:"smtp.exmail.qq.com",
        port:465,
        secure:true,
        auth:
            user:user,
            pass:pass

    transporter=nodemailer.createTransport(simpleconfig)
    transporter.sendMail mailoptions,(error,info)->
        _report_staus error,info

module.exports=sendmail
