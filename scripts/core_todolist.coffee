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
Table=require 'cli-table'



# -----------------------------------------------------------------------------------------
#  config info here , you can read from a safe config file
# -----------------------------------------------------------------------------------------
WUNDERLIST_TOKEN = process.env.WUNDERLIST_TOKEN
WUNDERLIST_CLIENT_ID = process.env.WUNDERLIST_CLIENT_ID

# -----------------------------------------------------------------------------------------
# Dependency
# -----------------------------------------------------------------------------------------
http=require 'http'
class Wunderlist

    constructor:(@auth_header)->
        @auth_header=@auth_header
        @host="a.wunderlist.com"

    get_lists:(cb)->
        @._get "/api/v1/lists",cb

    get_list_by_id:(id,cb)->
        @._get "/api/v1/lists/#{id}",cb

     get_tasks_by_list_id:(id,cb)->
        @._get "/api/v1/tasks?list_id=#{id}",cb

     _get:(path,cb)->
         opts=
             host:@host
             path:path
             port:80
             method:'GET'
             headers:@auth_header

            http.get opts,(res)->
                body=''
                res.on 'data',(d)->
                    body+=d
                res.on 'end',()->
                    cb(null,body)

# ----------------------------------------------------------------------------------------
#  do your job here
# -----------------------------------------------------------------------------------------
WL=new Wunderlist 'X-Access-Token': WUNDERLIST_TOKEN,'X-Client-ID':WUNDERLIST_CLIENT_ID


get_todo_lists = (cb)->

    WL.get_lists (lists)->
        console.log lists
        # cb lists


module.exports = (robot) ->
    # robot.hear /to\s*do/, (res)->
    #     tb=new Table head:['Here is your today un-finshed plan']
    #     get_todo_lists (lists)->
    #         for list in lists
    #             console.log list
                # tb.push [list]
            # res.send '\n'+tb.toString()
