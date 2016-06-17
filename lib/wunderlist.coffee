
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


module.exports=Wunderlist
