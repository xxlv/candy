# Description:
#  自动维护微信
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

chalk = require 'chalk'


# -----------------------------------------------------------------------------------------
#  config info here , you can read from a safe config file
# -----------------------------------------------------------------------------------------
BAIDU_API_KEY= 'f7347b399cf4a9ee3082a871aa93b0b3'
BAIDU_API_URL= 'http://apis.baidu.com/apistore/weatherservice/citylist'
BAIDU_TURING_URL= 'http://apis.baidu.com/turing/turing/turing'
BAIDU_TURING_KEY= '879a6cb3afb84dbf4fc84a1df2ab7319'

# -----------------------------------------------------------------------------------------
# Dependency
# -----------------------------------------------------------------------------------------
# EMPTY

# sendMass=(res,body,group,user='')->
#         wxrobot=res.robot.adapter.wxbot
#         wxrobot.sendMessage wxrobot.myUserName,group,user,body,(resp, resBody, opts) ->
#         # TODO

module.exports = (robot) ->


    robot.hear /(.*?)/, (res) ->
        input = res.match['input']
        # res.send input
        if input[0]!='@'
            wxrobot = res.robot.adapter.wxbot
            path = ''
            # wxrobot.webWxUploadAndSendMedia wxrobot.myUserName ,'',wxrobot.myUserName,path
            turingurl = BAIDU_TURING_URL + '?key='+BAIDU_TURING_KEY+'&info=' + input + "&userid=" + res.envelope.user.id
            robot.http(turingurl).header('apikey', BAIDU_API_KEY).get() (e, r, b) ->
                if ( ! input.match(/&lt;msg/))
                    b = JSON.parse b
                    res.send b.text
