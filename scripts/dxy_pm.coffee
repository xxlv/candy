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
request = require 'request'
chalk=require 'chalk'

PM_URL='http://pm.dxy.net'
PM_KEY=process.env.PM_KEY
PID=535 # vs pm project id


class Redmine

    constructor:(host)->
        @host=host
        @auth_header=[]

    listIssues:(pid,cb)->
        limit=1000
        api="#{@host}/issues.json?project_id=#{pid}&key=#{PM_KEY}"
        api=api.concat "&limit=#{limit}"
        api=api.concat "&assigned_to_id=me"
        api=api.concat "&sort=due_date:desc"

        @get api,cb


    updateIssue:(id,data,cb)->
        api="#{@host}/issues/#{id}.json?key=#{PM_KEY}"
        @put api,data,cb


    get:(api,cb)->
        request.get {url:api,json:true},(err,r,body)->
            cb null,body

    put:(api,data,cb)->
        @request "PUT",api,data,cb

    request:(method,url,data,cb) ->

        if typeof data isnt "string"
            data=JSON.stringify data

        req_body=
            method:method
            uri:url
            headers:
                'content-type':'application/json'
            body:data

        request req_body,(err,req,body) ->
            cb err,body

module.exports=(robot)->

    robot.hear /@pm/i,(res)->
        pm=new Redmine PM_URL

        pm.listIssues PID,(err,data) ->
            issues=data.issues
            for issue in issues
                priority_id=parseInt issue.priority.id
                status_id=parseInt issue.status.id

                if priority_id>=1 and status_id not in [7,6,5,9,8,2]
                    subject=issue.subject
                    priority_name=issue.priority.name
                    desc="id:#{issue.id}<br/>"
                    desc+="project:#{issue.project.name}<br/>"
                    desc+="start_date:#{issue.start_date}<br/>"
                    desc+="assigned_to:#{issue.assigned_to.name}<br/>"
                    desc+="author:#{issue.author.name}<br/>"
                    desc+="priority:#{issue.priority.name}<br/>"
                    desc+="status:#{issue.status.name}<br/>"
                    desc+="tracker:#{issue.tracker.name}<br/>"
                    desc+="due_date:#{issue.due_date}<br/>"
                    desc+="done_ratio:#{issue.done_ratio}<br/>"
                    desc+="created_on:#{issue.created_on}<br/>"
                    desc+="updated_on:#{issue.updated_on}<br/>"
                    desc+="closed_on:#{issue.closed_on}<br/>"
                    desc+="<hr/>:100:"
                    desc+=issue.description

                    gitlab_issue=
                        title:issue.subject
                        description:desc
                        labels:"PM"

                    # robot.emit "gitlab.add.issue", gitlab_issue
