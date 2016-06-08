# Description:
#  丁香医生接口,脚本提供简单的问答回复
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


DXY_QA_URL="http://dxy.com/view/i/columns/faq/qa/related"

genMsg =(res,data)->

    data=data.data
    res.send "喵呜😊😊😊😊😊我在丁香医生查到了"+data.total_items+"条数据,我只能挑最接近的一条给你\n"
    i=Math.floor((Math.random() * 1000))%(parseInt(10))
    if i>=parseInt(data.total_items)
        i=0

    setTimeout () ->
        res.send "你是不是在问:\n"+data.items[i].title+"\n"
    ,2000
    setTimeout () ->
        res.send "咯，答案是:\n"+data.items[i].answers[0].content+"\n"
    ,4000
    setTimeout () ->
        res.send "如果想知道更多的话，建议在http://dxy.com/仔细找找看哦！" if Math.random()>0.8
    ,6000

module.exports = (robot) ->

    robot.hear /(#|@)dxyer(.*)/i,(res)->

        matches=res.match
        prePage=10

        api=DXY_QA_URL+'?q='+matches[2]+'&items_per_page='+prePage
        robot.http(api).get() (error,r,body)->
            doctorSay=JSON.parse(body)
            res.send "哎呀，我找不到了！" if error
            if doctorSay.error then res.send "我找不到啦！"else genMsg res,doctorSay
