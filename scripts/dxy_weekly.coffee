# Description:
# 周报助手 自动生成周报
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# @gen a new weekly report - 生成新周报
#
# Author:
#   x


# 邮件相关配置
config= require './config'

MAIL_USER=config.MAIL_USER #邮件用户名
MAIL_PASS=config.MAIL_PASS     #邮件密码

# vs相关配置
VS_MAIL_FROM ='lvxx@dxy.cn'
VS_MAIL_TO= 'lvxinag119@gmail.com'
VS_MAIL_CC=['1252804799@qq.com']

#  生成邮件正文
genWeeklyMailBody=()->
    """
<div id="contentDiv" onclick="getTop().preSwapLink(event, 'html');" style="font-size:14px;height:auto;padding:15px 15px 10px 15px;*padding:15px 15px 0 15px;overflow:visible;min-height:100px;_height:100px;" class=" body"><div id="mailContentContainer" style="font-size: 14px; padding: 0px; height: auto; min-height: auto; font-family: 'lucida Grande', Verdana; margin-right: 170px;"><div><span style="font-family: '.SFNSText-Regular', 'SF UI Text', 'Lucida Grande', 'Segoe UI', Ubuntu, Cantarell, sans-serif; font-size: 1.2em; line-height: 1.2;"><b>本周</b></span></div><div><sign signid="0"><div style="color: rgb(144, 144, 144);"><div style="color: rgb(0, 0, 0);"><ul style="font-family: '.SFNSText-Regular', 'SF UI Text', 'Lucida Grande', 'Segoe UI', Ubuntu, Cantarell, sans-serif; font-size: 13.2px; line-height: 18.8571px; list-style: none; margin: 0px 0px 1.5em; padding: 15px; box-sizing: border-box;"><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;">微访谈基本完成</li></ul><div><span style="font-size: 13.2px; line-height: 19.8px;"><b>BUGs Fix</b></span></div><ul style="font-family: '.SFNSText-Regular', 'SF UI Text', 'Lucida Grande', 'Segoe UI', Ubuntu, Cantarell, sans-serif; font-size: 13.2px; line-height: 18.8571px; list-style: none; margin: 0px 0px 1.5em; padding: 15px; box-sizing: border-box;"><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;"><span style="color: rgb(102, 102, 102); line-height: 1.5; font-family: 'Helvetica Neue'; font-size: 15px; widows: auto;">点赞，分享功能</span></li><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;"><p style="line-height: 24px; widows: auto; font-family: 'Helvetica Neue'; font-size: 15px; margin: 0.667rem 0px;"><span style="color: rgb(102, 102, 102); line-height: 1.5; widows: auto;">talk开始、结束、进行中</span></p></li><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;"><p style="line-height: 24px; widows: auto; font-family: 'Helvetica Neue'; font-size: 15px; margin: 0.667rem 0px;"><span style="color: rgb(102, 102, 102); line-height: 1.5; widows: auto;">时间格式化输出</span></p></li><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;"><p style="line-height: 24px; widows: auto; font-family: 'Helvetica Neue'; font-size: 15px; margin: 0.667rem 0px;"><span style="color: rgb(102, 102, 102); line-height: 1.5; widows: auto;">后台配置修复</span></p></li><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;"><p style="line-height: 24px; widows: auto; font-family: 'Helvetica Neue'; font-size: 15px; margin: 0.667rem 0px;"><span style="color: rgb(102, 102, 102); line-height: 1.5; widows: auto;">banner图</span></p></li><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;"><p style="line-height: 24px; widows: auto; font-family: 'Helvetica Neue'; font-size: 15px; margin: 0.667rem 0px;"><span style="color: rgb(72, 72, 72); font-family: 'Helvetica Neue', helvetica, arial, sans-serif; font-size: 14px; line-height: 21px; widows: auto; background-color: rgb(255, 255, 255);">配置的起止时间不能正确保存</span></p></li><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;"><p style="line-height: 24px; widows: auto; font-family: 'Helvetica Neue'; font-size: 15px; margin: 0.667rem 0px;"><span style="color: rgb(72, 72, 72); line-height: 1.5em; text-decoration: initial; widows: auto; background-color: rgb(255, 255, 255);">草稿状态的微访谈页面仍然可以访问</span></p></li><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;"><p style="line-height: 24px; widows: auto; font-family: 'Helvetica Neue'; font-size: 15px; margin: 0.667rem 0px;"><span style="color: rgb(72, 72, 72); font-family: 'Helvetica Neue', helvetica, arial, sans-serif; font-size: 14px; line-height: 21px; widows: auto; background-color: rgb(255, 255, 255);">允许分享控制无效，选了“否”，页面分享控件应该不显示</span></p></li><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;"><p style="line-height: 24px; widows: auto; font-family: 'Helvetica Neue'; font-size: 15px; margin: 0.667rem 0px;"><span style="color: rgb(72, 72, 72); font-family: 'Helvetica Neue', helvetica, arial, sans-serif; font-size: 14px; line-height: 21px; widows: auto; background-color: rgb(255, 255, 255);">主持人点评在后台若配置为空，则前台不显示该模块</span></p></li><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;"><p style="line-height: 24px; widows: auto; font-family: 'Helvetica Neue'; font-size: 15px; margin: 0.667rem 0px;"><span style="color: rgb(102, 102, 102); line-height: 1.5; widows: auto;">无法上传文件问题修复</span></p></li><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;"><p style="line-height: 24px; widows: auto; font-family: 'Helvetica Neue'; font-size: 15px; margin: 0.667rem 0px;"><span style="color: rgb(102, 102, 102); line-height: 1.5; widows: auto;">后台显示调整，隐藏部分字段</span></p></li></ul><h4 id="-" style="font-family: '.SFNSText-Regular', 'SF UI Text', 'Lucida Grande', 'Segoe UI', Ubuntu, Cantarell, sans-serif; font-size: 1.2em; line-height: 1.2; margin: 1.5em 0px 0.5em; box-sizing: border-box;">下周</h4><ul style="font-family: '.SFNSText-Regular', 'SF UI Text', 'Lucida Grande', 'Segoe UI', Ubuntu, Cantarell, sans-serif; font-size: 13.2px; line-height: 18.8571px; list-style: none; margin: 0px 0px 1.5em; padding: 15px; box-sizing: border-box;"><li style="list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;">微话题</li></ul><div><br></div></div></div></sign></div><div><sign signid="0"><div style="color:#909090;font-family:Arial Narrow;font-size:12px"><br><br>------------------</div><div style="font-size:14px;font-family:Verdana;color:#000;"><div><pre class="js_message_plain ng-binding" ng-bind-html="message.MMActualContent" style="margin-top: 0px; margin-bottom: 0px; word-break: initial;"><div style="font-family: 'Arial Narrow'; line-height: normal; white-space: normal; color: rgb(144, 144, 144); font-size: 12px;"><br></div><div style="white-space: normal;"><div class="gmail_signature"><div dir="ltr"><div dir="ltr"><div dir="ltr"><div dir="ltr"><div style="text-align: -webkit-auto;"><div dir="ltr"><div style="text-align: -webkit-auto;"><p style="font-family: Tahoma; line-height: normal; font-size: 12px; font-weight: bold; margin-bottom: 5px; margin-top: 10px;">吕翔翔 LvXiang Xiang</p><p style="margin-top: 0px;"><span style="font-family: inherit; line-height: 18px; text-align: -webkit-auto; font-size: 12px;"><font face="Tahoma">PHP Development Engineer</font></span><font face="Tahoma" color="#666666" style="font-family: inherit; line-height: normal;"><span style="font-size: 11px; line-height: 18px;">&nbsp;| Professional Services Division | </span></font><a href="http://www.dxy.cn/" target="_blank" style="font-family: Tahoma; line-height: 18px; outline: none; text-decoration: none; color: rgb(102, 102, 102); font-size: 11px;">DXY.cn</a><br><font face="Tahoma" color="#666666" style="font-family: inherit; line-height: normal;"><span style="font-size: 11px; line-height: 18px;">Office: </span></font><a href="http://www.dxy.cn/" target="_blank" style="font-family: Tahoma; line-height: 18px; outline: none; text-decoration: none; color: rgb(102, 102, 102); font-size: 11px;">+86-571-2818-2617</a><font face="Tahoma" color="#666666" style="font-family: inherit; line-height: normal;"><span style="font-size: 11px; line-height: 18px;">&nbsp; | &nbsp;Mobile: </span></font><a href="http://www.dxy.cn/" target="_blank" style="font-family: Tahoma; line-height: 18px; outline: none; text-decoration: none; color: rgb(102, 102, 102); font-size: 11px;">+86-170-8689-</a><font color="#666666" face="Tahoma"><span style="font-size: 12px; line-height: 18px;">4013</span></font></p></div></div></div></div></div></div></div></div></div></pre></div>
</div></sign></div><div>&nbsp;</div> </div></div>
    """

# resport send status
report_staus=(error,info)->
    console.log(info)
    console.log("发送邮件失败！"+ error) if error

# Send Mail
sendmail=(f,to,cc,body='',html='')->
    user=MAIL_USER
    pass=MAIL_PASS
    w_date='(2016/6/1-2016/6/2)'
    nodemailer=require "nodemailer"
    subject="吕翔翔的周报"+w_date

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
        report_staus error,info


module.exports=(robot)->
    robot.hear /@gen a new weekly report/i,(res)->
        # 获取最新hash
        from =VS_MAIL_FROM
        to = VS_MAIL_TO
        cc=VS_MAIL_CC
        body=''
        html=genWeeklyMailBody()
        sendmail from,to,cc,body,html
        res.send 'Well,Job done!'
