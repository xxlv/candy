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

Wunderlist=require '../../lib/wunderlist'
config=require './../config'

WUNDERLIST_TOKEN=config.WUNDERLIST_TOKEN
WUNDERLIST_CLIENT_ID=config.WUNDERLIST_CLIENT_ID


WL=new Wunderlist 'X-Access-Token': WUNDERLIST_TOKEN,'X-Client-ID':WUNDERLIST_CLIENT_ID


_send_to_group=(name)->
    wxrobot=res.robot.adapter.wxbot
    group=''

    for k,v of wxrobot.groupInfo
        console.log k
        if v == 'VS专职团队'
            group = k

_check_list=(lists,robot)->

    today=new Date
    diff_day=2
    compare_d=new Date((today/1000+86400*diff_day)*1000)
    share=list for list in lists when list.title=='分享选题'

    if share?
        WL.get_tasks_by_list_id share.id ,(err,tasks...)->
            if tasks?
                tasks=JSON.parse tasks
                for task in tasks
                    if task.due_date?
                        dd=task.due_date
                        if parseInt(Date.parse compare_d) >= parseInt(Date.parse dd) and  parseInt(Date.parse today) <= parseInt(Date.parse dd)
                            if !task.completed
                                console.log "Found a new task #{task.title},the due date is #{task.due_date} "


_check_share = (robot) ->
    WL.get_lists (err,lists)->
        _check_list JSON.parse lists, robot



module.exports = (robot)->
    run:(robot)->
        _check_share robot
