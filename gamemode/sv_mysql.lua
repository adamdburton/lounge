-- MySQL functions
-- Takes the pain away a little

-- module include
require('mysqloo')

-- config
local config = {
	hostname = 'localhost',
	port = 3306,
	username = 'root',
	password = '',
	database = 'lounge'
}

local connection
local connecting = false
local connected = false
local queue = {}

-- connects to the database
function GM:MySQLConnect()
	if connecting then return end
	
	connecting = true
	
	connection = mysqloo.connect(config.hostname, config.username, config.password, config.database, config.port)
	
	connection.onConnected = function()
		connected = true
		connecting = false
		MsgN('[Lounge] MySQL Connected!')
	end
	
	connection.onConnectionFailed = function(connection, err)
		connected = false
		connecting = false
		MsgN('[Lounge] MySQL connection failed: ' .. err)
	end
	
	connection:connect()
end

-- adds a query to the queue to run
function GM:MySQLQuery(sql, binds, callback)
	if not connected then self:MySQLConnect() end
	
	if not binds then binds = {} end
	if not callback then callback = function() end end
	
	for _, v in pairs(binds) do
		sql = string.gsub(sql, "?", "'" .. connection:escape(tostring(v)) .. "'", 1)
	end
	
	table.insert(queue, {SQL = sql, Callback = callback})
end

-- runs queries in the queue
function GM:MySQLThink()
	if not connected then self:MySQLConnect() return end
	
	if #queue < 1 then return end
	
	MsgN('[Lounge] ' .. #queue .. ' queries in queue...')
	
	local q = table.remove(queue, 1)
	
	local query = connection:query(q.SQL)
	
	query.onSuccess = function(query, data)
		q.Callback(data)
	end
	
	query.onError = function(query, err, sql)
		MsgN('[Lounge] MySQL query failed: ' .. err .. ' (' .. sql .. ')')
	end
	
	query:start()
end