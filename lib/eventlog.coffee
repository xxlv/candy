

class MysqlAdapter

    constructor:(@host,@user,@pass)->
        @host=@host
        @user=@user
        @pass=@pass


class EventAdapter

    constructor:(@adapter)->
        @adapter=@adapter

    get:(k)->
        @adapter.get k

    put:(k,v)->
        @adapter.put k,v

    delete:(k)->
        @adapter.delete k


class EventLog extends EventAdapter

    constructor:(@adapter) ->
        super @adapter


module.exports=EventLog
