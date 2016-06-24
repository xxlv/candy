# Description:
#  show your todo list
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
# todo -  list all toto items
#
# Author:
#   x

chalk= require 'chalk'
config= require './config'
Table=require 'cli-table'
Wunderlist=require '../lib/wunderlist'

WUNDERLIST_TOKEN=config.WUNDERLIST_TOKEN
WUNDERLIST_CLIENT_ID=config.WUNDERLIST_CLIENT_ID
WL=new Wunderlist 'X-Access-Token': WUNDERLIST_TOKEN,'X-Client-ID':WUNDERLIST_CLIENT_ID


get_todo_lists = (cb)->

    WL.get_lists (lists)->
        console.log lists
        # cb lists


module.exports = (robot) ->

    robot.hear /to\s*do/, (res)->
        tb=new Table head:['Here is your today un-finshed plan']
        get_todo_lists (lists)->
            for list in lists
                console.log list
                # tb.push [list]
            # res.send '\n'+tb.toString()
