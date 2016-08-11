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


chalk=require 'chalk'

# -----------------------------------------------------------------------------------------
#  config info here , you can read from a safe config file
# -----------------------------------------------------------------------------------------
MAIL_USER= "lvxx@dxy.cn"
MAIL_PASS= process.env.MAIL_PASS
GITLAB_TOKEN= process.env.GITLAB_TOKEN
GITLAB_BASE_URL= 'http://gitlab.dxy.net'
GITLAB_PROJECT_ID= 86
VS_MAIL_FROM= 'lvxx@dxy.cn'
VS_MAIL_TO= 'mzhang@dxy.cn'
VS_PUBLISH_MANAGER='manager'
VS_GITLAB_BRANCH= 'master'
VS_MAIL_CC= ['lujb@dxy.cn','houjy@dxy.cn','lvxx@dxyer.com','wangjb@dxy.cn']

# VS flush time url
vs_flush_time_online_url='http://e.dxy.cn/grep/cns/flush-time-rand'
vs_flush_time_local_url='http://vs.sim.dxy.net/grep/cns/flush-time-rand'



# ----------------------------------------------------------------------------------------
#  do your job here
# -----------------------------------------------------------------------------------------
# init gitlab
gitlab=(require 'gitlab')
    url:GITLAB_BASE_URL,
    token:GITLAB_TOKEN

#  生成邮件正文
_genPushMailBody=(manager,branch,commitHash,reasons=[],author='x')->
    """
    <div style="font-family: 'lucida Grande', Verdana; line-height: normal;">
    <sign signid="0"><div style="color: rgb(144, 144, 144); font-family: 'Arial Narrow'; font-size: 12px;">
    <div style="color: rgb(0, 0, 0); font-family: 'lucida Grande', Verdana; font-size: 14px; line-height: normal;">
    Hi #{manager}：</div><div style="color: rgb(0, 0, 0); font-family: 'lucida Grande', Verdana; font-size: 14px; line-height: normal;"><sign signid="0"><div style="line-height: normal;"><b><br></b></div><div><sign signid="0">
    <div style="line-height: normal;">virtual station 版本更新，需要发布，<span style="line-height: 1.5;">
    当前开发分支位于：<b>#{branch}</b></span><span style="line-height: 1.5;">。</span></div>
    <div style="line-height: normal;"><br></div>
    <div style="line-height: normal;">commit :#{commitHash}</div>
    <div style="line-height: normal;"><br></div>
    <div><br></div><div style="line-height: normal;">
    <b>更新摘要#{"(最后更新人:#{author})"}</b>：</div><div style="line-height: normal;"><br></div>
    #{("<div style='line-height: normal;'>－ #{item}</div>" for item in reasons ).join('<br/>')}
    </sign></div></sign></div></div></sign>
    <div style='font-size:12px;float:right;'>(----该邮件由机器人自动发送)</div>
    </div>
    """

# resport send status
_report_staus=(error,info)->
    console.log(info)
    console.log("发送邮件失败！"+ error) if error


# send mail
_sendmail=(f,to,cc,body='',html='')->

    user=MAIL_USER
    pass=MAIL_PASS
    nodemailer=require "nodemailer"
    subject="VS线上版本发布!!!"

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
        _report_staus error,info


# Mass message
_sendMass=(res,body,group,user='')->

    if res.robot.adapter.wxbot
        wxrobot=res.robot.adapter.wxbot
        wxrobot.sendMessage wxrobot.myUserName,group,user,body,(resp, resBody, opts) ->


module.exports=(robot)->
    # help
    robot.hear /@vs-help/i,(res)->
        help='#'+"vs-help (😃Can i help u ?)\n\n"
        help+='#'+"vs pub a new version (自动发送发布最新版本的邮件)\n\n"
        help+='#'+"使用方法，在该群输入指令，可自动执行计划\n\n"
        res.send help

    # flush time
    robot.hear /@\s?vs flush(.*)/i,(res)->

        if 'online'==res.match[1].trim()
            url=vs_flush_time_online_url
        else
            url=vs_flush_time_local_url

        robot.http(url).get() (e,r,b)->
            res.send "#{url} says: #{b}"


    # 发布一个新版本 自动发送邮件给管理员
    # 自动从gitlab分支获取，并且将commit自动填充到摘要里面
    robot.hear /@\s?vs publish a new version(!?)/i, (res)->

        preview=if '!'==res.match[1] then false else true

        # gitlab.projects.repository.showCommit GITLAB_PROJECT_ID,VS_GITLAB_BRANCH, (body)->
            # console.log body
            # commit=JSON.parse(body)
            #
            # # 获取最新hash
            # from =VS_MAIL_FROM
            # to = VS_MAIL_TO
            # cc=VS_MAIL_CC
            # body=''
            # manager=VS_PUBLISH_MANAGER
            # branch=VS_GITLAB_BRANCH
            # commitHash=commit.short_id
            # reason=[commit.title]
            # html=_genPushMailBody manager,branch,commitHash,reason,commit.author_name
            #
            #
            # msg="VS 新版本发布报告😏😏😏\n"
            # msg+="邮件发送给  #{manager}\n"
            # msg+="分支 : #{branch}\n"
            # msg+="最后修改人 : #{commit.author_name}\n"
            # msg+="Commit : #{commitHash}\n"
            # msg+="reson : #{reason}\n"
            # msg+='输入#vs-help 查看全部指令'
            #
            # unless preview
            #     res.send chalk.red "\n"+'send mail to '+to+"\n"
            #     # _sendmail from,to,cc,body,html
            #
            # res.send msg
            # _sendMass res,msg,group,'' if group?

        api=GITLAB_BASE_URL+"/api/v3/projects/"+GITLAB_PROJECT_ID+"/repository/commits/"+VS_GITLAB_BRANCH
        robot.http(api).header('PRIVATE-TOKEN', GITLAB_TOKEN).get() (err,r,body)->

            if err
                res.send "获取git commit 失败😓！"
            else
                commit=JSON.parse(body)
                # 获取最新hash
                from =VS_MAIL_FROM
                to = VS_MAIL_TO
                cc=VS_MAIL_CC
                body=''
                manager=VS_PUBLISH_MANAGER
                branch=VS_GITLAB_BRANCH
                commitHash=commit.short_id
                reason=[commit.title]
                html=_genPushMailBody manager,branch,commitHash,reason,commit.author_name


                msg="VS 新版本发布报告😏😏😏\n"
                msg+="邮件发送给  #{manager}\n"
                msg+="分支 : #{branch}\n"
                msg+="最后修改人 : #{commit.author_name}\n"
                msg+="Commit : #{commitHash}\n"
                msg+="reson : #{reason}\n"

                unless preview
                    _sendmail from,to,cc,body,html
                    res.send chalk.red "\n"+'send mail to '+to+"\n"
                    _sendMass res,msg,group,'' if group?

                res.send msg
