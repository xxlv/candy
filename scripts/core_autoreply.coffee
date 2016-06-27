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
config = require './config'

{EventLog} = require '../lib/eventlog'

BAIDU_API_KEY = config.BAIDU_API_KEY
BAIDU_API_URL = config.BAIDU_API_URL
BAIDU_TURING_URL = config.BAIDU_TURING_URL
BAIDU_TURING_KEY = config.BAIDU_TURING_KEY


# sendMass=(res,body,group,user='')->
#         wxrobot=res.robot.adapter.wxbot
#         wxrobot.sendMessage wxrobot.myUserName,group,user,body,(resp, resBody, opts) ->
#         # TODO

module.exports = (robot) ->
    # robot.hear /(.*?)/, (res) ->
    #     input = res.match['input']
    #     if input[0]!='@'
    #         wxrobot = res.robot.adapter.wxbot
    #         path = ''
    #         # wxrobot.webWxUploadAndSendMedia wxrobot.myUserName ,'',wxrobot.myUserName,path
    #         turingurl = BAIDU_TURING_URL + '?key='+BAIDU_TURING_KEY+'&info=' + input + "&userid=" + res.envelope.user.id
    #         robot.http(turingurl).header('apikey', BAIDU_API_KEY).get() (e, r, b) ->
    #             if ( ! input.match(/&lt;msg/))
    #                 b = JSON.parse b
    #                 res.send b.text
