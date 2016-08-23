# Description:
#  Gitlab
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
# @list issues - list all gitlab issue
# @issue <opt> <id> - like @issue close 12 , the issue will be colosed
#
# Author:
#   x

chalk=require 'chalk'
Table=require 'cli-table'


request=require 'request'
GITLAB_PROJECT_ID= 86
GITLAB_TOKEN= process.env.GITLAB_TOKEN
GITLAB_BASE_URL= 'http://gitlab.dxy.net'


module.exports=(robot)->

    gitlab=new Gitlab GITLAB_BASE_URL,GITLAB_TOKEN
    # listeners
    robot.on 'gitlab.add.issue',(issue)->
        gitlab.addIssue  GITLAB_PROJECT_ID,issue,(err,body)->
            # console.log "I created a new issue for u \n #{issue.title}"

    robot.on 'gitlab.update.issue',(issue)->
        gitlab.updateIssue GITLAB_PROJECT_ID,issue,(err,body)->
            # console.log "I updated a issue , the id is #{issue.issue_id}"
    robot.on 'gitlab.push',(body) ->
        commit_ops body

    robot.hear /@list issues/i ,(res)->
        gitlab.listIssues GITLAB_PROJECT_ID,(err,body)->
            body=JSON.parse body
            table=new Table {head:['id','title','state','updated_at','author']}
            for item in body
                if item.state=='opened'
                    table.push [item.id,item.title,item.state,item.updated_at,item.author.name]
            console.log "\n"+table.toString()



    # close a issue
    robot.hear /@issue (.*?) (.*)/i,(res) ->
        state_event=res.match[1]
        issue_id=parseInt res.match[2]
        issue=
            issue_id:issue_id
            state_event:state_event

        robot.emit 'gitlab.update.issue',issue
        robot.emit 'pm.update.issue',issue
        res.send "I #{state_event} a issue,id is #{issue_id} "



# Gitlab simple implement
class Gitlab

    constructor:(url,token)->
        @url=url
        @token=token

    addIssue:(pid,issue,cb) ->
        api="#{@url}/api/v3/projects/#{pid}/issues"
        @post api,issue,cb

    updateIssue:(pid,issue,cb)->
        id=issue.issue_id
        api="#{@url}/api/v3/projects/#{pid}/issues/#{id}"
        @put api,issue,cb

    listIssues:(pid,cb)->
        api="#{@url}/api/v3/projects/#{pid}/issues"
        @get api,cb


    get:(api,cb) ->
        @request api,'GET',{},cb

    put:(api,data,cb)->
        @request api ,'PUT',data,cb

    post:(api,data,cb) ->
        @request api,'POST',data,cb

    request:(api,method,data,cb)->

        data=JSON.stringify data
        context=
            url:api
            method:method
            headers:
                "PRIVATE-TOKEN":@token
                "Content-Type":"application/json"
            body:data

        request context,(err,response,body)->
            cb err,body

# commit ops
commit_ops=(body) ->

    body=JSON.parse body if typeof body isnt "object"
    total_commits_count=body.total_commits_count
    commits=body.commits
    for commit in commits
        console.log "New commit(@#{commit.id}) comming : #{chalk.red commit.message} "
