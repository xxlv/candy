# Description:
#  发送消息
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

chalk= require 'chalk'

# -----------------------------------------------------------------------------------------
#  config info here , you can read from a safe config file
# -----------------------------------------------------------------------------------------
MAIL_USER= "lvxx@dxy.cn"
MAIL_PASS= process.env.MAIL_PASS


_sendmail=(subject,f,to,cc,body='',html='')->

    user=MAIL_USER
    pass=MAIL_PASS
    nodemailer=require "nodemailer"
    subject=subject

    mailoptions=
        from :f,
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
        #




module.exports = (robot) ->
    robot.on 'mail',(data)->
        _sendmail data.subject,MAIL_USER,data.to,null,data.msg,null

    # robot.hear /@\s*mailto*/i , (res)->
        # to = res.match[1].trim()
        # msg=res.match[2].trim()
        # from=config.VS_MAIL_FROM
        # subject=msg.substring 0,18  if msg.nil?

        # console.log res.match
        # _sendmail subject,from,to,null,msg,null
        # res.send chalk.bold 'Send a mail to ' + chalk.red "#{to} "+ chalk.white '  MSG IS  '+chalk.bold msg
