# ------------------------------------------------------------------------------
# Virtual Station 项目助手
#
# @author x
# @email  lvxang119@gmail.com
# @github https://github.com/xxlv
# @blog  http://www.0x10.me/
# ------------------------------------------------------------------------------

# 邮件相关配置
config= require './config'

MAIL_USER=config.MAIL_USER #邮件用户名
MAIL_PASS=config.MAIL_PASS     #邮件密码

# vs相关配置
VS_MAIL_FROM ='lvxx@dxy.cn'
VS_MAIL_TO= 'lvxinag119@gmail.com'
VS_MAIL_CC=['1252804799@qq.com']


module.exports=(robot)->
    robot.hear /#vs flush/i,(res)->
        res.send 'Well,Job done!'
