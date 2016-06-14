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

config= require './config'

BAIDU_API_KEY=config.BAIDU_API_KEY
BAIDU_API_URL=config.BAIDU_API_URL
BAIDU_TURING_URL=config.BAIDU_TURING_URL
BAIDU_TURING_KEY=config.BAIDU_TURING_KEY


# sendMass=(res,body,group,user='')->
#         wxrobot=res.robot.adapter.wxbot
#         wxrobot.sendMessage wxrobot.myUserName,group,user,body,(resp, resBody, opts) ->
#         # TODO

module.exports = (robot) ->

    # robot.hear /天气/, (res)->
    #     api= BAIDU_API_URL
    #     apikey=BAIDU_API_KEY
    #     cityname='杭州'
    #     api=api+'?cityname='+cityname
    #     robot.http(api).header('apikey',apikey).get() (e,r,b)->
    #         b=JSON.stringify(b)
    #         if b.errNum==0
    #             res.send b.retData[0].province_cn+b.retData[0].district_cn+'的天气'
    # 图灵机器人
    robot.hear /(.*?)/, (res)->

        input=res.match['input']
        if input[0]!='@'
            # wxrobot=res.robot.adapter.wxbot
            path=''
            # wxrobot.webWxUploadAndSendMedia wxrobot.myUserName ,'',wxrobot.myUserName,path
            turingurl=BAIDU_TURING_URL+'?key='+BAIDU_TURING_KEY+'&info='+input+"&userid="+res.envelope.user.id
            robot.http(turingurl).header('apikey',BAIDU_API_KEY).get() (e,r,b)->
                if (!input.match(/&lt;msg/))
                    b=JSON.parse b
                    res.send b.text
                    # setTimeout ()->
                    # , 1000



    robot.hear /(#|@)x(.*)/i,(res)->
        res.send "😬you can not see me ~~~zzzz！" if Math.random > 0.8
        res.send "hi,it'me ,what can i do for u ?" if Math.random <0.5

    robot.hear /bug/i,(res)->
        res.send "Don't worry i can fix that!"

    robot.hear /(还是不行|not work)/i,(res)->
        res.send "😊 please clear cache and try again!"

    robot.hear /早点睡吧/i,(res)->
        res.send "晚安😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊"
