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

SSH_PRIVATE_KEY_PATH='/Users/xxlv/.ssh/id_rsa'
SERVER_IP='192.168.200.27'
SERVER_USERNAME='dxy'


# VS flush time url
vs_flush_time_online_url='http://vs.dxy.cn/admin/cron/flush-time'
vs_flush_time_local_url='http://vs.sim.dxy.net/admin/cron/flush-time'


# ----------------------------------------------------------------------------------------
#  do your job here
# -----------------------------------------------------------------------------------------
# init gitlab
gitlab=(require 'gitlab')
    url:GITLAB_BASE_URL,
    token:GITLAB_TOKEN

#  Gen mail body
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

# Resport send status
_report_staus=(error,info)->
    console.log(info)
    console.log("发送邮件失败！"+ error) if error


# Send mail
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

# create a note on gitlab
log_gitlab=(msg,robot)->
    issue_id=13
    api=GITLAB_BASE_URL+"/api/v3/projects/"+GITLAB_PROJECT_ID+"/issues/#{issue_id}/notes"
    data = JSON.stringify({
        body: msg
    })
    robot.http(api)
    .header('PRIVATE-TOKEN', GITLAB_TOKEN)
    .header('Content-Type', 'application/json')
    .post(data) (err,r,body)->
        body=JSON.parse body
        if body.id
            console.log chalk.red "Auto sync gitlab by #{body.author.name}"

ssh_cp=(branch)->

    Client=(require 'ssh2').Client
    conn=new Client
    cmd="cd /var/www/virtual-station && git pull origin #{branch}"
    console.log "Run cmd : #{cmd}"
    conn.on 'ready', ->
        conn.exec cmd,(err,stream)->
            if err
                throw err
            stream.on 'close',(code,signal)->
                conn.end
            .on 'data',(data)->
                console.log data.toString()
            .stderr.on 'data',(data)->
                console.log "SAY :#{data}"

    .connect {
        host:SERVER_IP,
        port:22,
        username:SERVER_USERNAME,
        privateKey: require('fs').readFileSync(SSH_PRIVATE_KEY_PATH)
    }


module.exports=(robot)->
    # Help
    robot.hear /@vs-help/i,(res)->
        help='#'+"vs-help (😃Can i help u ?)\n\n"
        help+='#'+"vs pub a new version (自动发送发布最新版本的邮件)\n\n"
        help+='#'+"使用方法，在该群输入指令，可自动执行计划\n\n"
        res.send help
    # Flush time
    robot.hear /@\s?vs flush(.*)/i,(res)->

        if 'online'==res.match[1].trim()
            url=vs_flush_time_online_url
        else
            url=vs_flush_time_local_url

        robot.http(url).get() (e,r,b)->
            res.send "#{url} says: #{b}"

    # ----------------------------------------------------------------------------------------
    # 发布一个新版本 自动发送邮件给管理员
    # 自动从gitlab分支获取，并且将commit自动填充到摘要里面
    # -----------------------------------------------------------------------------------------
    robot.hear /@\s?vs publish a new version(!?)/i, (res)->

        preview=if '!'==res.match[1] then false else true

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

                msg="VS 新版本发布报告\n"
                msg+="邮件发送给  #{manager}\n"
                msg+="分支 : #{branch}\n"
                msg+="最后修改人 : #{commit.author_name}\n"
                msg+="Commit : #{commitHash}\n"
                msg+="reson : #{reason}\n"
                unless preview
                    gitlab_msg="**VS 新版本发布报告:100:**<br/>
                                邮件发送给:  #{manager}<br/>
                                分支 : #{branch}<br/>
                                最后修改人 :#{commit.author_name}<br/>
                                Commit : #{commitHash}<br/>
                                reson : #{reason}<br/>
                                "
                    _sendmail from,to,cc,body,html
                    log_gitlab gitlab_msg,robot
                    res.send chalk.red "\n"+'send mail to '+to+"\n"
                res.send msg

    # ----------------------------------------------------------------------------------------
    # Update source from gitlab on test server
    # -----------------------------------------------------------------------------------------
    robot.hear /@\s?push(.*)/i,(res)->
        branch=res.match[1].trim()
        if branch == ''
            branch='master'
        ssh_cp branch
