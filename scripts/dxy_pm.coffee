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

    robot.hear /pm/i,(res)->
        pm=new Redmine PM_URL
        #
        # attributes =
        #   "notes": "note"
        #
        # id=64256
        # pm.updateIssue id,attributes,(err,data) ->
        #     console.log data

        pm.listIssues PID,(err,data) ->
            issues=data.issues
            for issue in issues
                priority_id=parseInt issue.priority.id
                status_id=parseInt issue.status.id

                if priority_id>=5 and status_id not in [7,6,5,9,8,2]
                    subject=issue.subject
                    priority_name=issue.priority.name

                    gitlab_issue=
                        title:issue.subject
                        description:issue.description
                        labels:"PM"

                    robot.emit "gitlab.add.issue", gitlab_issue


                    #
                    # subject=chalk.bold subject
                    # priority_name=chalk.bold chalk.red priority_name
                    #
                    # msg="#{issue.id}@ #{issue.author.name} -> #{chalk.green "我"} :"+
                    #     "<#{priority_name}> #{subject} "
                    #
                    # if issue.due_date?
                    #     msg+="at #{issue.due_date}"
                    # console.log msg
