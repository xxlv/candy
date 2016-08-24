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

ask_for_dinner=(robot,name)->
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

    console.log  "I ordered dinner for #{name} at #{moment().format('YYYY-MM-DD hh:m:s')}"

    # request.post dinner_api,context,(err,response,body) ->
    #     body=JSON.parse body
    #     if  body.code is 0
    #         console.log  "I ordered dinner for #{name} at #{moment().format('YYYY-MM-DD hh:m:s')}"
    #     else
    #         console.log  'Whoops,订餐失败啦～'



module.exports = (robot) ->
    robot.on 'dxy.dinner',(name)->
        ask_for_dinner robot,name


    robot.hear /@dinner(.*)/,(res) ->
        name=res.match[1].trim()
        ask_for_dinner robot,name
