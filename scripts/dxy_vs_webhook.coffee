# Description:
# Virtual Station web hooks
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# @gen a new weekly report - 生成新周报
#
# Author:
#   x


deal_push=(b,res)->
    if b.object_kind=='push'
        branch=b.ref
        branch=branch.split 'refs/heads/'
        branch=branch[1]
        console.log b
        console.log branch
    return

deal_issue=(b,res)->
    return

deal_comment=(b,res)->
    if b.object_kind=='note'
        console.log "Recive new note : #{b.object_attributes.note}"
    return

deal_merge=(b,res)->
    return

deal_build=(b,res)->
    return

deal_wiki=(b,res)->
    return


deal_tag=(b,res)->
    return


module.exports=(robot)->
    robot.router.get '/vs/hook', (req, res) ->
        res.send 'OK'

    robot.router.post '/vs/hook',(req,res)->

        body=req.body
        deal_push body,res
        deal_issue body,res
        deal_comment body,res
        deal_merge body,res
        deal_build body,res
        deal_wiki body,res
        deal_tag body,res
