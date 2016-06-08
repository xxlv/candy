# Description:
#  丁香园 站点发布脚本，自动给管理员发送发布邮件
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


config=require './config'

# 邮件相关配置
MAIL_USER=config.MAIL_USER
MAIL_PASS=config.MAIL_PASS

# gitlab相关配置
GITLAB_TOKEN=config.GITLAB_TOKEN # TOKEN 非常重要
GITLAB_BASE_URL=config.GITLAB_BASE_URL
GITLAB_PROJECT_ID=config.GITLAB_PROJECT_ID # project id ，可以通过抓包获得，也可以走api，如果有权限的话

# vs相关配置
VS_MAIL_FROM =config.VS_MAIL_FROM
VS_MAIL_TO= config.VS_MAIL_TO
VS_PUBLISH_MANAGER=config.VS_PUBLISH_MANAGER
VS_GITLAB_BRANCH=config.VS_GITLAB_BRANCH
VS_MAIL_CC=config.VS_MAIL_CC

#  生成邮件正文
genPushMailBody=(manager,branch,commitHash,reasons=[],author='x')->
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
report_staus=(error,info)->
    console.log(info)
    console.log("发送邮件失败！"+ error) if error


# Send Mail
sendmail=(f,to,cc,body='',html='')->

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
        report_staus error,info


sendMass=(res,body,group,user='')->

    wxrobot=res.robot.adapter.wxbot
    # console.log wxrobot.groupInfo
    wxrobot.sendMessage wxrobot.myUserName,group,user,body,(resp, resBody, opts) ->
    #


module.exports=(robot)->


    robot.hear /#vs-help/i,(res)->
        help='#'+"vs-help (😃Can i help u ?)\n\n"
        help+='#'+"vs pub a new version (自动发送发布最新版本的邮件)\n\n"
        help+='#'+"使用方法，在该群输入指令，可自动执行计划\n\n"
        res.send help


    # 发布一个新版本 自动发送邮件给管理员
    # 自动从gitlab分支获取，并且将commit自动填充到摘要里面
    robot.hear /#vs pub a new version/i,(res)->
        wxrobot=res.robot.adapter.wxbot
        group=''
        for k,v of wxrobot.groupInfo
            if v == 'VS专职团队'
                group = k

        api=GITLAB_BASE_URL+"/api/v3/projects/"+GITLAB_PROJECT_ID+"/repository/commits/"+VS_GITLAB_BRANCH
        robot.http(api).header('PRIVATE-TOKEN', GITLAB_TOKEN).get() (err,r,body)->

            if err
                res.send "获取git commit 失败😓！"
            else
                commit=JSON.parse(body)
                # console.log commit
                # 获取最新hash
                from =VS_MAIL_FROM
                to = VS_MAIL_TO
                cc=VS_MAIL_CC
                body=''
                manager=VS_PUBLISH_MANAGER
                branch=VS_GITLAB_BRANCH
                commitHash=commit.short_id
                reason=[commit.title]
                html=genPushMailBody manager,branch,commitHash,reason,commit.author_name

                # sendmail from,to,cc,body,html

                msg="VS 新版本发布报告😏😏😏\n"
                msg+="邮件发送给  #{manager}\n"
                msg+="分支 : #{branch}\n"
                msg+="最后修改人 : #{commit.author_name}\n"
                msg+="Commit : #{commitHash}\n"
                msg+='输入#vs-help 查看全部指令'

                res.send msg
                # sendMass res,msg,group,'' if group?
