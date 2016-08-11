# Description:
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   x

# 邮件相关配置
MAIL_USER= 'lvxx@dxy.cn'
MAIL_PASS= process.env.MAIL_PASS

# resport send status
_report_staus=(error,info)->
    if error
        console.log("发送邮件失败！"+ error)
    else
        console.log "send mail to #{info.accepted}"



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
