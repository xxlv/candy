# Description:
#  笔记
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


{Evernote}=require 'evernote'

module.exports = (robot) ->
    robot.hear /sendx/, (res) ->
        token='S=s61:U=a5a4a8:E=15d4077712b:C=155e8c641b8:P=1cd:A=en-devtoken:V=2:H=13c61fefe02a93892664552e5014937e'
        client=new Evernote.Client {token:token}
        notestore=client.getNoteStore()
        notestore.listLinkedNotebooks (n)->
            console.log n
