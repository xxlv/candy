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
# @gen a new weekly report - gen a new weekly report
#
# Author:
#   x


chalk=require 'chalk'
moment=require 'moment'

# -----------------------------------------------------------------------------------------
#  config info here , you can read from a safe config file
# -----------------------------------------------------------------------------------------
MAIL_USER= "lvxx@dxy.cn"
MAIL_PASS= process.env.MAIL_PASS
VS_MAIL_FROM ='lvxx@dxy.cn'
VS_MAIL_TO= ['mzhang@dxy.cn','zjw@dxy.cn','biz@dxy.cn']
VS_MAIL_CC=['wl@dxy.cn','fank@dxy.cn']
GITLAB_TOKEN= process.env.GITLAB_TOKEN
GITLAB_BASE_URL= 'http://gitlab.dxy.net'


#  生成邮件正文
genWeeklyMailBody=(t,n)->
    """
    <div style="font-size:14px;height:auto;padding:15px 15px 10px 15px;*padding:15px 15px 0 15px;overflow:visible;min-height:100px;_height:100px;" class=" body">
    <div id="mailContentContainer" style="font-size: 14px; padding: 0px; height: auto; min-height: auto; font-family: 'lucida Grande', Verdana; margin-right: 170px;">
    <div><span style="font-family: '.SFNSText-Regular', 'SF UI Text', 'Lucida Grande', 'Segoe UI', Ubuntu, Cantarell, sans-serif; font-size: 1.2em; line-height: 1.2;">
    <h4 id="-" style="font-family: '.SFNSText-Regular', 'SF UI Text', 'Lucida Grande', 'Segoe UI', Ubuntu, Cantarell, sans-serif; font-size: 1.2em; line-height: 1.2; margin: 1.5em 0px 0.5em; box-sizing: border-box;">本周</h4>
    <ul style="font-family: '.SFNSText-Regular', 'SF UI Text', 'Lucida Grande', 'Segoe UI', Ubuntu, Cantarell, sans-serif; font-size: 13.2px; line-height: 18.8571px; list-style: none; margin: 0px 0px 1.5em; padding: 15px; box-sizing: border-box;">
    #{("<li style='list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;'>#{thisweektask}</li>" for thisweektask in t).join('<br/>')}
    </ul>
    <h4 id="-" style="font-family: '.SFNSText-Regular', 'SF UI Text', 'Lucida Grande', 'Segoe UI', Ubuntu, Cantarell, sans-serif; font-size: 1.2em; line-height: 1.2; margin: 1.5em 0px 0.5em; box-sizing: border-box;">下周</h4>
    <ul style="font-family: '.SFNSText-Regular', 'SF UI Text', 'Lucida Grande', 'Segoe UI', Ubuntu, Cantarell, sans-serif; font-size: 13.2px; line-height: 18.8571px; list-style: none; margin: 0px 0px 1.5em; padding: 15px; box-sizing: border-box;">
    #{("<li style='list-style: disc; margin: 0px; padding: 0px; box-sizing: border-box;'>#{nextweektask}</li>" for nextweektask in n).join('<br/>')}
    </ul>
    <div>
    <br></div></div></div></sign></div><div><sign signid="0">
    <div style="color:#909090;font-family:Arial Narrow;font-size:12px"><br><br>------------------</div>
    <div style="font-size:14px;font-family:Verdana;color:#000;">
    <div><pre class="js_message_plain ng-binding" ng-bind-html="message.MMActualContent" style="margin-top: 0px; margin-bottom: 0px; word-break: initial;">
    <div style="font-family: 'Arial Narrow'; line-height: normal; white-space: normal; color: rgb(144, 144, 144); font-size: 12px;"><br></div>
    <div style="white-space: normal;"><div class="gmail_signature"><div dir="ltr"><div dir="ltr"><div dir="ltr"><div dir="ltr"><div style="text-align: -webkit-auto;"><div dir="ltr"><div style="text-align: -webkit-auto;">
    <p style="font-family: Tahoma; line-height: normal; font-size: 12px; font-weight: bold; margin-bottom: 5px; margin-top: 10px;">吕翔翔 LvXiang Xiang</p>
    <p style="margin-top: 0px;"><span style="font-family: inherit; line-height: 18px; text-align: -webkit-auto; font-size: 12px;"><font face="Tahoma">PHP Development Engineer</font></span><font face="Tahoma" color="#666666" style="font-family: inherit; line-height: normal;"><span style="font-size: 11px; line-height: 18px;">&nbsp;| Professional Services Division | </span></font><a href="http://www.dxy.cn/" target="_blank" style="font-family: Tahoma; line-height: 18px; outline: none; text-decoration: none; color: rgb(102, 102, 102); font-size: 11px;">DXY.cn</a><br><font face="Tahoma" color="#666666" style="font-family: inherit; line-height: normal;"><span style="font-size: 11px; line-height: 18px;">Office: </span></font><a href="http://www.dxy.cn/" target="_blank" style="font-family: Tahoma; line-height: 18px; outline: none; text-decoration: none; color: rgb(102, 102, 102); font-size: 11px;">+86-571-2818-2617</a><font face="Tahoma" color="#666666" style="font-family: inherit; line-height: normal;"><span style="font-size: 11px; line-height: 18px;">&nbsp; | &nbsp;Mobile: </span></font><a href="http://www.dxy.cn/" target="_blank" style="font-family: Tahoma; line-height: 18px; outline: none; text-decoration: none; color: rgb(102, 102, 102); font-size: 11px;">+86-170-8689-</a><font color="#666666" face="Tahoma"><span style="font-size: 12px; line-height: 18px;">4013</span></font></p></div></div></div></div></div></div></div></div></div></pre></div>
    </div></sign></div><div>&nbsp;</div> </div></div>
    """

# resport send status
report_staus=(error,info)->
    console.log("发送邮件失败！"+ error) if error
    console.log chalk.red  "Send a mail to #{chalk.bold info.envelope.to}"

get_week_begin_and_end=()->

    dt    = new Date
    begin = new Date
    end   = new Date
    day   =7-dt.getDay()
    date  =dt.getDate()
    begin.setDate(date-day+1)
    end.setDate(date+(7-day))
    [begin,end]

getweekly_task=(cb)->
    # project_id=86
    # name='x'
    # week_begin_and_end=get_week_begin_and_end()
    #
    # gitlab=(require 'gitlab')
    #     url:GITLAB_BASE_URL
    #     token:GITLAB_TOKEN
    #
    # # 获取全部分支
    # # 扫描分支 按照本周日期遍历
    # gitlab.projects.listCommits id:project_id,(commits)->
    #     this_task=[]
    #     next_task=[]
    #     for commit in commits
    #         date=new Date commit.created_at
    #         if date>=week_begin_and_end[0] and date <=week_begin_and_end[1]
    #             if commit.author_name==name
    #                 this_task.push commit
    #
    #     tasks=
    #         t:message.title for message in this_task
    #         n:message for message in next_task
    #
        tasks=
            t:[
                '批量标签编辑新增全局选中（之前批量选中当前页）',
                '积分配置发布'
            ]
            n:[
                '第三套模版匿名模式',
            ]
        cb tasks

# Send Mail
sendmail=(f,to,cc,body='',html='')->
    name='吕翔翔'
    user=MAIL_USER
    pass=MAIL_PASS

    week_begin_and_end=get_week_begin_and_end()
    # w_date=''
    w_date="#{moment(week_begin_and_end[0]).format('YYYY/MM/DD')}-#{moment(week_begin_and_end[1]).format('YYYY/MM/DD')}"
    nodemailer=require "nodemailer"
    subject="#{name}的周报"+w_date

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
    console.log subject
    transporter.sendMail mailoptions,(error,info)->
        report_staus error,info


module.exports=(robot)->

    robot.hear /@gen\s*a\s*new\s*weekly\s*report(!?)/i,(res)->

        preview=if '!'==res.match[1] then false else true
        # 获取最新hash
        from =VS_MAIL_FROM
        to = VS_MAIL_TO
        cc=VS_MAIL_CC

        getweekly_task (tasks)->
            html=genWeeklyMailBody(tasks.t,tasks.n)
            unless preview
                sendmail from,to,cc,"",html
            else
                table=new (require 'cli-table') head:["Items preview"]
                for task in tasks.t
                    table.push [task]
                res.send "\n"+table.toString()
