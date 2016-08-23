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


ifaces =os.networkInterfaces()
company_ip= '192.168.200.179'

_get_current_evn_ip=()->
    for ifa of ifaces
        return ifaces['en0'][1].address if ifaces['en0'][1].address
    ""
_get_pm_count=()->
    2

ask_for_dinner=(robot,name,res)->

    data=
        name:"#{name}"
        meetingId:"411"
        meetingTitle:"杭州办晚餐预订"
        teamId:"82"
        applicationId:"6"
        accountType:"3"

    # data=querystring.stringify data
    dinner_api='https://sim.dxy.cn/plugins/do/meeting/submitapply'

    context=
        url:dinner_api
        method:'POST'
        headers:
            "Content-Type":"application/x-www-form-urlencoded"
        form:data

    request.post dinner_api,context,(err,response,body) ->
        body=JSON.parse body
        if parseInt body.code is 0
            console.log  "I ordered dinner for #{name} at #{new Date}"
        else
            console.log  body



module.exports = (robot) ->

    robot.hear /@dinner(.*)/,(res) ->
        name=res.match[1].trim()
        ask_for_dinner robot,name,res
