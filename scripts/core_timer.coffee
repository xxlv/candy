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

check_every_thing=(robot)->
    robot.emit 'check.dxy.dinner'


doIt=(robot)->
    check_every_thing robot

    setTimeout ()->
        doIt(robot)
    ,3000

module.exports=(robot) ->
    setTimeout ()->
        doIt(robot)
    ,3000
