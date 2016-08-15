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

    dinner_api='https://sim.dxy.cn/plugins/do/meeting/submitapply'

    data=JSON.stringify data
    robot.http(dinner_api)
    # .header('Content-Type', 'application/json')
    .post(data) (err,res,body)->
        # res.send "I ordered dinner for #{name} at #{new Date}"
        



module.exports = (robot) ->

    robot.hear /@dinner(.*)/,(res) ->
        name=res.match[1].trim()
        ask_for_dinner robot,name,res
