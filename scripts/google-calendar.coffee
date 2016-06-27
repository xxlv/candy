# Description:
#  谷歌日历
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

fs = require('fs')
readline = require('readline')
google = require('googleapis')
googleAuth = require('google-auth-library')
Table=require 'cli-table'
moment=require 'moment'
mailto=require './share/mailto'

# If modifying these scopes, delete your previously saved credentials
# at ~/.credentials/calendar-nodejs-quickstart.json
SCOPES = [ 'https://www.googleapis.com/auth/calendar.readonly' ]
TOKEN_DIR = (process.env.HOME or process.env.HOMEPATH or process.env.USERPROFILE) + '/.credentials/'
TOKEN_PATH = TOKEN_DIR + 'calendar-nodejs-quickstart.json'
# Load client secrets from a local file.

###*
# Create an OAuth2 client with the given credentials, and then execute the
# given callback function.
#
# @param {Object} credentials The authorization client credentials.
# @param {function} callback The callback to call with the authorized client.
###

authorize = (credentials,res,callback) ->

  clientSecret = credentials.installed.client_secret
  clientId = credentials.installed.client_id
  redirectUrl = credentials.installed.redirect_uris[0]
  auth = new googleAuth
  oauth2Client = new (auth.OAuth2)(clientId, clientSecret, redirectUrl)
  # Check if we have previously stored a token.
  fs.readFile TOKEN_PATH, (err, token) ->
    if err
      getNewToken oauth2Client, callback
    else
      oauth2Client.credentials = JSON.parse(token)
      callback oauth2Client,res
    return
  return

###*
# Get and store new token after prompting for user authorization, and then
# execute the given callback with the authorized OAuth2 client.
#
# @param {google.auth.OAuth2} oauth2Client The OAuth2 client to get token for.
# @param {getEventsCallback} callback The callback to call with the authorized
#     client.
###
getNewToken = (oauth2Client, callback) ->
  authUrl = oauth2Client.generateAuthUrl(
    access_type: 'offline'
    scope: SCOPES)
  console.log 'Authorize this app by visiting this url: ', authUrl
  rl = readline.createInterface(
    input: process.stdin
    output: process.stdout)
  rl.question 'Enter the code from that page here: ', (code) ->
    rl.close()
    oauth2Client.getToken code, (err, token) ->
      if err
        console.log 'Error while trying to retrieve access token', err
        return
      oauth2Client.credentials = token
      storeToken token
      callback oauth2Client
      return
    return
  return

###*
# Store token to disk be used in later program executions.
#
# @param {Object} token The token to store to disk.
###

storeToken = (token) ->
  try
    fs.mkdirSync TOKEN_DIR
  catch err
    if err.code != 'EEXIST'
      throw err
  fs.writeFile TOKEN_PATH, JSON.stringify(token)
  console.log 'Token stored to ' + TOKEN_PATH
  return

###*
# Lists the next 10 events on the user's primary calendar.
#
# @param {google.auth.OAuth2} auth An authorized OAuth2 client.
###

listEvents = (auth,res) ->
  calendar = google.calendar('v3')
  calendar.events.list {
    auth: auth
    calendarId: 'primary'
    timeMin: (new Date).toISOString()
    maxResults: 10
    singleEvents: true
    orderBy: 'startTime'
  } , (err, response) ->
    if err
      res.send 'The API returned an error: ' + err
      return
    events = response.items
    if events.length == 0
      res.send 'No upcoming events found.'
    else
      tb=new Table head:['Date','Plan']
      i = 0
      while i < events.length
        event = events[i]
        start = event.start.dateTime or event.start.date
        tb.push ["#{moment(start).fromNow()}","#{event.summary}"]
        i++
    res.send "\n"+tb.toString()


_makeTableHtml=(title,events)->

    console.log events
    start=moment().startOf('week').toISOString()
    end =moment().endOf('week').toISOString()
    start=moment(start).format 'YYYY-MM-DD'
    end =moment(end).format 'YYYY-MM-DD'

    html="<center><h4>#{start}-#{end}</h4></center>"
    html+="<h5>#{title}</h5>"
    html+="<table border='1' cellspacing='0' cellpadding='0'><tbody>"
    html+="<tr style='background-color:gray'>"
    html+="<th style='width:200px'>Start</th>"
    html+="<th style='width:200px'>End</th>"
    html+="<th style='width:200px'>Diff</th>"
    html+="<th style='width:200px'>Plan</th>"
    html+="<th style='width:200px'>Link</th>"
    html+="<th style='width:200px'>Completed</th>"
    html+="</tr>"
    i = 0
    total=events.length
    not_completed=0

    while i < events.length
        event = events[i]

        if event.summary.match /\!$/
            completed_staus=1
        else
            completed_staus=0
            not_completed++

        html+="<tr>"
        start = event.start.dateTime or event.start.date
        end = event.end.dateTime or event.end.date

        html+="<td>#{moment(start).fromNow()}</td>"
        html+="<td>#{moment(end).fromNow()}</td>"
        html+="<td>#{moment(start).diff(moment(end),'minutes')} m</td>"

        html+="<td>#{event.summary}</td>"
        html+="<td><a href='#{event.htmlLink}'>Link</a></td>"
        if completed_staus!=1
            html+="<td style='color:red;'>X</td>"
        else
            html+="<td style='color:green;'>√</td>"

        html+="</tr>"
        i++
    html+="</tbody></table>"

    html


mailEventsAutoWeek=(auth,res)->

    calendar = google.calendar('v3')
    calendar.events.list {
      auth: auth
      calendarId: 'primary'
      timeMin: moment().startOf('week').toISOString(),
      timeMax: moment().endOf('week').toISOString(),
      singleEvents: true
      orderBy: 'startTime'
    },(err,response)->
        if err
            return
        events = response.items
        html=_makeTableHtml 'TODO LIST',events

        title ='New plan report list comming!'
        to="1252804799@qq.com"
        start=moment().startOf('week').toISOString()
        end =moment().endOf('week').toISOString()
        start=moment(start).format 'YYYY年MM月DD日'
        end =moment(end).format 'YYYY年MM月DD日'

        mailto to,"Notice! #{start}-#{end} New plan report list comming!",html


module.exports = (robot) ->

    robot.hear /maillist/,(res)->
        fs.readFile "#{TOKEN_DIR}/client_secret.json", (err, content) ->
            if err
                console.log 'Error loading client secret file: ' + err
                return
            else
                authorize JSON.parse(content), res,mailEventsAutoWeek

    robot.hear /todo/, (res) ->
        fs.readFile "#{TOKEN_DIR}/client_secret.json", (err, content) ->
            if err
                console.log 'Error loading client secret file: ' + err
                return
            else
                authorize JSON.parse(content), res,listEvents
