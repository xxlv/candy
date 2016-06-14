# Description:
#  Virtual Station 项目助手
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# @vs flush  - 刷新时间戳
# @vs flush online - 刷新线上时间戳
#
# Author:
#   x


# 邮件相关配置
config= require './config'

MAIL_USER=config.MAIL_USER #邮件用户名
MAIL_PASS=config.MAIL_PASS     #邮件密码

# vs相关配置
VS_MAIL_FROM ='lvxx@dxy.cn'
VS_MAIL_TO= 'lvxinag119@gmail.com'
VS_MAIL_CC=['1252804799@qq.com']

vs_flush_time_online_url='http://e.dxy.cn/grep/cns/flush-time-rand'
vs_flush_time_local_url='http://vs.sim.dxy.net/grep/cns/flush-time-rand'

module.exports=(robot)->

    robot.hear /@vs flush(.*)/i,(res)->

        if 'online'==res.match[1].trim()
            url=vs_flush_time_online_url
        else
            url=vs_flush_time_local_url


        robot.http(url).get() (e,r,b)->
            res.send "#{url} says: #{b}"
