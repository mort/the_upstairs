// Building on dealer.js (https://github.com/technoweenie/dealer.js) to experiment with a Redis-based user list

var redisClient = require("redis-client"),
         dealer = require("../lib"),
            sys = require('sys'),
            url = require('url')

var port      = process.env['PORT'] || 3840
var redisConf = process.env['REDIS_URL'] || "redis://127.0.0.1:6379/0"

conn = dealer.create()
conn.server.listen(port)

sys.puts("listening on " + port)

conn.addListener('connect', function(client) {
	sys.puts('connected to ' + sys.inspect(client.channels) + ': '+ client.id)
})

// Injecting the credentials checking into the socket lifecycle
conn.addListener('connect', function(client) {
	sys.puts('Checking auth for' + sys.inspect(client.channels) + ': '+ client.id)
	checkAuth(client);	
})

conn.addListener('disconnect', function(client) {
  sys.puts('disconnected: ' + client.id)
})

conn.addListener('receive', function(client, data) {
  sys.puts('MSG from ' + client.id + sys.inspect(client.channels) + ': ' + data)
	conn.sendToChannel(client.channels.shift(), data)
})

redisConf   = url.parse(redisConf)
redisDb = redisConf.pathname.substr(1)
redis   = redisClient.createClient(redisConf.port, redisConf.hostname);

// We'll need a second client to perform non pubsub operations
redis2  = redisClient.createClient(redisConf.port, redisConf.hostname); 


// We tweak a little bit the dealer.js redis pubsub bit to allow for sending non-chat/administrative messages to the chat channels
redis.stream.on("connect", function () {
  redis.select(redisDb, function(a) {
    redis.subscribeTo("commchannels:*:announcements", function (channel, message) {
      sys.puts("ANN to " + channel + ": " + message)
      var channel_str = String(channel)
      var channel_arr = channel_str.split(':')
      var channel_id = channel_arr[1]
      conn.sendToChannel(channel_id, "ANN: "+message)
    })
  })
})


// A redis set as a whitelist for authorized user ids, so we can SADD to the user list from a web interface, restful API calls, etc.

function checkAuth(client) {

	var debug = false

	var channel_id = client.channels[client.channels.length-1]
	var channel_key = 'commchannels:'+channel_id+':members'
	var client_id = parseInt(client.id)
	
  redis2.select(redisDb, function(a) {  
		redis2.sismember(channel_key, client_id, function (err, result) {
			sys.puts(client_id+ " is member of "+channel_key+": " + result)

			if (err != null) {
				sys.puts(sys.inspect(err))					
			}
						
			if (result == 0) {
				client.send("You are not entitled to this conversation. Bye!")
				conn.disconnect(client)
			} 
			else if (result == 1){
				client.send("Please, be welcome.")
				return client
			}
			
			
		})
		
		if (debug) {
			redis2.smembers(channel_key,function(err,members){
				if (err != null) {
					sys.puts(sys.inspect(err))					
				}
				sys.puts("Members: "+members)
			})
		}
		
	})
}