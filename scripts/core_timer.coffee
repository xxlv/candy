# Description:
# Timer
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
# None
#
# Author:
#   x

moment=require 'moment'

check_every_thing=(robot)->
    random=Math.random()*100
    hour=moment().hour()
    
    robot.emit 'check.dxy.dinner' if hour>=12 and hour<=16






doIt=(robot)->
    check_every_thing robot
    setTimeout ()->
        doIt(robot)
    ,1000

module.exports=(robot) ->
    setTimeout ()->
        doIt(robot)
    ,3000
