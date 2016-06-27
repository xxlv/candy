
{ CronJob } = require 'cron'
chalk = require('chalk')
Fs = require 'fs'

class HubotCron

  constructor: (@pattern, @timezone, @fn, @context = global) ->
    @cronjob = new CronJob(
      @pattern
      @onTick.bind(this)
      null
      false
      @timezone
    )
    if 'function' != typeof @fn
      throw new Error "the third parameter must be a function, got (#{typeof @fn}) instead"
    @cronjob.start()

  stop: ->
    @cronjob.stop()

  onTick: ->
    Function::call.apply @fn, @context

runCrons = (robot) ->
    path = __dirname + '/cron/'
    if Fs.existsSync(path)
        for file in Fs.readdirSync(path).sort()
            try
                script = require(path + file)
                new script().run(robot)
            catch error
                console.log "#{error.stack}"


module.exports = (robot) ->
    pattern = '* * * * *'
    timezone = 'Asia/Shanghai'
    runCrons robot

    # fn= ->
    #     runCrons robot
    # new HubotCron pattern,timezone,fn
