rs232 = require("luars232")
require "luasql.mysql"

port_name = "/dev/ttyACM0"

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

local out = io.stderr


local e, p = rs232.open(port_name)
if e ~= rs232.RS232_ERR_NOERROR then
	
	out:write(string.format("can't open serial port '%s', error: '%s'\n",
			port_name, rs232.error_tostring(e)))
	return
end


assert(p:set_baud_rate(rs232.RS232_BAUD_9600) == rs232.RS232_ERR_NOERROR)
assert(p:set_data_bits(rs232.RS232_DATA_8) == rs232.RS232_ERR_NOERROR)
assert(p:set_parity(rs232.RS232_PARITY_NONE) == rs232.RS232_ERR_NOERROR)
assert(p:set_stop_bits(rs232.RS232_STOP_1) == rs232.RS232_ERR_NOERROR)
assert(p:set_flow_control(rs232.RS232_FLOW_OFF)  == rs232.RS232_ERR_NOERROR)

sleep(12)


-- write without timeout
err, len_written = p:write("temp")
assert(e == rs232.RS232_ERR_NOERROR)
sleep(2)

local read_len = 4 -- read one byte
local timeout = 100 -- in miliseconds
local err, temp, size = p:read(read_len, timeout)
assert(e == rs232.RS232_ERR_NOERROR)
			
print(temp);
-- write without timeout
err, len_written = p:write("humi")
assert(e == rs232.RS232_ERR_NOERROR)
sleep(2)

local read_len = 2 -- read one byte
local timeout = 100 -- in miliseconds
local err1, humi, size1 = p:read(read_len, timeout)
assert(e == rs232.RS232_ERR_NOERROR)
			
print(humi);
-- write without timeout
err, len_written = p:write("pres")
assert(e == rs232.RS232_ERR_NOERROR)
sleep(2)

local read_len = 4 -- read one byte
local timeout = 100 -- in miliseconds
local err2, pres, size2 = p:read(read_len, timeout)
assert(e == rs232.RS232_ERR_NOERROR)
			
print(pres);

err, len_written = p:write("wind")
assert(e == rs232.RS232_ERR_NOERROR)
sleep(2)

local read_len = 2 
local timeout = 100 
local err3, wind, size3 = p:read(read_len, timeout)
assert(e == rs232.RS232_ERR_NOERROR)
			
print(wind);


-- close
assert(p:close() == rs232.RS232_ERR_NOERROR)

--Start communication with MySQL Database


envv = assert (luasql.mysql())
con = assert (envv:connect('DATABASENAME', 'USERNAME', 'PASSWORDHERE', "HOSTNAME", '3306'))

ymonth = os.date("%m")
unix = os.time()
time = os.date()
hour1 = os.date("%H")
day1 = os.date("%w")
month1 = os.date("%d")
    

  -- add a few elements
  list = {
    { unixtime=unix, timestamp=time, yearmonth= ymonth, month=month1, day=day1, hour=hour1, temperature=temp, pressure=pres, wind=wind, humidity=humi  }
    
  }
  for i, p in pairs (list) do
    res = assert (con:execute(string.format([[
      INSERT INTO weatherValues3
      VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')]],p.unixtime, p.timestamp, p.yearmonth, p.month, p.day, p.hour, p.temperature, p.pressure, p.wind, p.humidity)
    ))
  end

  con:close()

