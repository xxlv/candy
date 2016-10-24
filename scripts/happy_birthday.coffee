# Description:
# Happy birthday to my friends
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
#
#
# Author:
#   ghost



#
# class HappyBirthday
#     constructor:(@myname)->
#         @myname=@myname
#
#     happy_birthday_to:(@user,@msg) ->
#         @send @user ,@msg
#
#
#
#     send:(@user,@msg)->
#         return if @user.name is nil
#
#
#
#
module.exports=(robot)->
    robot.hear /happy/i,(res)->
        res.send "Happy u"
