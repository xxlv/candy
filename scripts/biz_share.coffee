# Description:
#  自动检测分享
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

# -----------------------------------------------------------------------------------------
#  config info here , you can read from a safe config file
# -----------------------------------------------------------------------------------------
WUNDERLIST_TOKEN = process.env.WUNDERLIST_TOKEN
WUNDERLIST_CLIENT_ID = process.env.WUNDERLIST_CLIENT_ID
# -----------------------------------------------------------------------------------------
# Dependency
# -----------------------------------------------------------------------------------------
http=require 'http'
class Wunderlist

    constructor:(@auth_header)->
        @auth_header=@auth_header
        @host="a.wunderlist.com"

    get_lists:(cb)->
        @._get "/api/v1/lists",cb

    get_list_by_id:(id,cb)->
        @._get "/api/v1/lists/#{id}",cb

     get_tasks_by_list_id:(id,cb)->
        @._get "/api/v1/tasks?list_id=#{id}",cb

     _get:(path,cb)->
         opts=
             host:@host
             path:path
             port:80
             method:'GET'
             headers:@auth_header

            http.get opts,(res)->
                body=''
                res.on 'data',(d)->
                    body+=d
                res.on 'end',()->
                    cb(null,body)

# ----------------------------------------------------------------------------------------
#  do your job here
# -----------------------------------------------------------------------------------------
WL = new Wunderlist 'X-Access-Token': WUNDERLIST_TOKEN,'X-Client-ID': WUNDERLIST_CLIENT_ID
_send_to_group = (name) ->
    wxrobot = res.robot.adapter.wxbot
    group = ''

    for k, v of wxrobot.groupInfo
        console.log k
        if v == 'VS专职团队'
            group = k

_check_list = (lists, robot) ->

    today = new Date
    diff_day = 2
    compare_d = new Date((today / 1000 + 86400 * diff_day) * 1000)
    share = list for list in lists when list.title == '分享选题'

    console.log share

    if share?
        WL.get_tasks_by_list_id share.id , (err, tasks...) ->
            if tasks?
                tasks = JSON.parse tasks
                for task in tasks
                    console.log task
                    if task.due_date?
                        dd = task.due_date
                        if parseInt(Date.parse compare_d) >= parseInt(Date.parse dd) and parseInt(Date.parse today) <= parseInt(Date.parse dd)
                            if ! task.completed
                                console.log "Found a new task #{task.title},the due date is #{task.due_date} "
                                return
_check_share = (robot) ->
    WL.get_lists (err, lists) ->
        _check_list JSON.parse lists, robot


module.exports = (robot) ->
    robot.hear /share/,(res) ->
        _check_share robot
