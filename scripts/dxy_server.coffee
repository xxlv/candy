# Description:
#  服务器相关监控
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



chalk=require 'chalk'



vs_local_host='192.168.200.27'
vs_online_host='https://vs.dxy.cn'

_get_target_status=(res,target,server,what_params)->

    msg=chalk.bold "IP :" + chalk.red vs_local_host
    res.send msg


module.exports = (robot) ->
    robot.hear /@ list (.*?) (.*?) (.*?)/i,(res)->
        target= res.match[1]
        server=res.match[2]
        what_params=res.match[3]
        _get_target_status res,target,server,what_params
