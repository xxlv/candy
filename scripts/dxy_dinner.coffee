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
#
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


ask_for_dinner=(robot)->

    dinner_api='https://sim.dxy.cn/plugins/do/meeting/apply/411/82/6?ticket=DQPns5IcB06sGPjEzHYxfSNTXqXE4ehJ8VhAw231O0ZrXw99CQbaN3nKJNENdZX5'
    robot.http(dinner_api).post() (e,r,b)->
        # todo
        console.log 'dinner '


module.exports = (robot) ->

    robot.hear /dinner/,(res) ->
        ask_for_dinner robot
