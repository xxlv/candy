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
    robot.emit 'check.dxy.dinner'



doIt=(robot)->
    check_every_thing robot
    setTimeout ()->
        doIt(robot)
    ,1000*3

module.exports=(robot) ->
    doIt(robot)
