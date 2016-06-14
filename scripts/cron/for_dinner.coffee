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

get_current_evn_ip=()->
    for ifa of ifaces
        return ifaces['en0'][1].address if ifaces['en0'][1].address
    ""


dinner=(robot)->
    # 检测到没有定过晚餐
    # 检测到ip是在公司
    # 检测到时间是在下午4点
    # 检测到pm上 截止日期为今日的的数量>=2
    now=new Date
    h=now.getHours()
    d=now.getDay()

    in_company= if get_current_evn_ip() is company_ip then true else false
    in_current_time=if d >= 1 && d <=5 && h==8 then true else false



module.exports = (robot) ->
    run:(robot)->
        dinner robot
