# Description:
#  Timmer
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

HB_DXY_DINNER_DB_HOST='localhost'
HB_DXY_DINNER_DB_NAME='a3'
HB_DXY_DINNER_DB_USER='root'
HB_DXY_DINNER_DB_PASSWORD=''

mysql=require 'mysql'
moment=require 'moment'

checkable=true

conn=mysql.createConnection {
    host:HB_DXY_DINNER_DB_HOST,
    user:HB_DXY_DINNER_DB_USER,
    password:HB_DXY_DINNER_DB_PASSWORD
    database:HB_DXY_DINNER_DB_NAME
}

dinner=(robot,data) ->
    now_hour=moment().format("HH:mm")
    dinner_time= data.dinner_time.substring 0,5

    return if now_hour!=dinner_time

    today=moment().format("YYYY-DD-MM").toString()
    begin_at=new Date data.begin_at
    end_at=new Date data.end_at
    name=data.name

    mail_body={
        subject:'Dinner',
        to:data.email,
        msg:"I ordered dinner for #{name} at #{moment().format('YYYY-MM-DD hh:m:s')}"
    }

    if moment().isBefore(end_at) && moment().isAfter(begin_at)
        conn.query "SELECT * FROM dinners_log WHERE uid=#{data.uid} AND dt='#{today}'",(err,rows,fields) ->
            if rows.length==0
                sql="INSERT INTO dinners_log (uid,dt,status) VALUES ('#{data.uid}','#{today}','1')";
                conn.query sql,(err,rows,fields)->
                    robot.emit 'mail',mail_body
                    robot.emit 'dxy.dinner',name


#
module.exports = (robot) ->
    robot.on 'check.dxy.dinner', (data)->
        conn.query 'SELECT * FROM dinners WHERE 1 = 1 ',(err,rows,fields)->
            if err
                throw err
            for row in rows
                dinner robot,row
