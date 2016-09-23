# Description:
#  自动定晚餐
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
# dinner $NAME - dinner for u
# Author:
#   x

os =require 'os'
request=require 'request'
querystring=require 'querystring'
moment=require 'moment'

ifaces =os.networkInterfaces()
company_ip= '192.168.200.179'

_get_current_evn_ip=()->
    for ifa of ifaces
        return ifaces['en0'][1].address if ifaces['en0'][1].address
    ""
_get_pm_count=()->
    2

ask_for_dinner=(robot,ask_data)->
    name=ask_data.name
    uid=ask_data.uid

    data=
        name:"#{name}"
        meetingId:"411"
        meetingTitle:"杭州办晚餐预订"
        teamId:"82"
        applicationId:"6"
        accountType:"3"
        token:"QT4DUhukNjjpnE0g70lVUAq2wfJil-xsmWmHzxyyT54"

    # data=querystring.stringify data
    dinner_api='https://sim.dxy.cn/plugins/do/meeting/submit_apply'

    context=
        url:dinner_api
        method:'POST'
        headers:
            "Content-Type":"application/x-www-form-urlencoded"
        form:data

    request.post dinner_api,context,(err,response,body) ->
        # body=JSON.parse body
        # if  body.code is 0
        robot.emit 'dxy.dinner.noticications',uid
        #     console.log  "I ordered dinner for #{name} at #{moment().format('YYYY-MM-DD hh:m:s')}"
        # else
        #     console.log  'Whoops,订餐失败啦～'



module.exports = (robot) ->
    dinner_notifications_api='http://127.0.0.1/notify'

    robot.on 'dxy.dinner',(name)->
        ask_for_dinner robot,name

    robot.on 'dxy.dinner.noticications',(uid)->
        data=JSON.stringify {id:uid}

        robot.http(dinner_notifications_api)
         .header('Content-Type', 'application/json')
         .post(data) (err,res,body)->


    robot.hear /@dinner(.*)/,(res) ->
        name=res.match[1].trim()
        ask_for_dinner robot,name
