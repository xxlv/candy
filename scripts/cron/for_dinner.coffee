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
    # todo
    2


_ask_for_dinner=(robot)->

    dinner_api='https://sim.dxy.cn/plugins/do/meeting/apply/411/82/6?ticket=DQPns5IcB06sGPjEzHYxfSNTXqXE4ehJ8VhAw231O0ZrXw99CQbaN3nKJNENdZX5'
    robot.http(dinner_api).post() (e,r,b)->
        # todo






dinner=(robot)->

    # 检测到没有定过晚餐
    # 检测到ip是在公司
    # 检测到时间是在下午4点
    # 检测到pm上 截止日期为今日的的数量>=2
    now=new Date
    h=now.getHours()
    d=now.getDay()

    not_ask_for_dinner=true
    in_company= if _get_current_evn_ip() is company_ip then true else false
    in_current_time=if d >= 1 && d <=5 && h==16 then true else false
    pm_aleady_done=if _get_pm_count() < 2 then true else false

    _ask_for_dinner robot

    if in_company && in_current_time && pm_aleady_done && not_ask_for_dinner
        _ask_for_dinner robot


module.exports = (robot) ->

    run:(robot)->
        dinner robot
