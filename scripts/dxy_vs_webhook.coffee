# Description:
# Virtual Station web hooks
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
#
#
# Author:
#   x



# -----------------------------------------------------------------------------------------
#  config info here , you can read from a safe config file
# -----------------------------------------------------------------------------------------
SSH_PRIVATE_KEY_PATH='/Users/xxlv/.ssh/id_rsa'
SERVER_IP='192.168.200.27'
SERVER_USERNAME='dxy'


chalk=require 'chalk'

deal_push=(b,res,robot)->
    if b.object_kind=='push'

        branch=b.ref
        branch=branch.split 'refs/heads/'
        branch=branch[1]
        user_name=b.user_name
        user_email=b.user_email
        project=b.project.name
        commit_count=b.total_commits_count
        commits=b.commits

        ssh_cp branch
        msg="#{user_name}(#{user_email}) push #{commit_count} commits on #{project} -> #{branch}"
        for commit in commits
            msg+="\n Message:#{commit.message}  modified:#{chalk.red commit.modified.join(",")} "
        console.log chalk.bold msg

    return

deal_issue=(b,res)->
    return

deal_comment=(b,res)->
    if b.object_kind=='note'
        console.log "Recive new note : #{b.object_attributes.note}"
    return

deal_merge=(b,res)->
    return

deal_build=(b,res)->
    return

deal_wiki=(b,res)->
    return

deal_tag=(b,res)->
    return


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

    robot.router.post '/vs/hook',(req,res)->

        body=req.body
        deal_push body,res,robot
        deal_issue body,res
        deal_comment body,res
        deal_merge body,res
        deal_build body,res
        deal_wiki body,res
        deal_tag body,res
