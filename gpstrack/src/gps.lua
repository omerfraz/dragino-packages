m = Map("gpstrack", translate("GPS Track Server"), translate("Where the gateway reports GPS positions"))

s = m:section(NamedSection, "general", "gpstrack", translate("GPS Service"))
local tt = s:option(ListValue, "gps_service", "GPS Service")
tt:value("disabled", "Disabled")
tt:value("gpswox", "GPSWOX")
tt:value("targtec", "TARGTEC Server")
tt.default = "disabled"

s = m:section(NamedSection, "gpswox", "gpstrack", translate("GPSWOX"))

s:option(Value, "username", translate("Username"),translate("Username of gpswox.com"))

local pass = s:option(Value, "password", translate("Password"),translate("Password of gpswox.com"))
pass.password = true

local t = s:option(ListValue, "server", translate("Map Server"))
t:value("109.235.65.195", "Europe Tracking Server")
t:value("107.170.92.234", "USA Tracking Server")
t:value("128.199.127.94", "Asia Tracking Server")
t.default = "128.199.127.94"

-- TARGTEC: the IVMS tracking server (track.targtec.com). Positions go over the OsmAnd HTTP protocol on
-- port 5055; the device must exist in TrackMap with this Device ID (its IMEI / unique id).
s = m:section(NamedSection, "targtec", "gpstrack", translate("TARGTEC Server"))

local ts = s:option(Value, "server", translate("Server"), translate("The TARGTEC tracking server"))
ts.datatype = "host"
ts.default = "track.targtec.com"

local tp = s:option(Value, "port", translate("Port"), translate("OsmAnd protocol port of the server"))
tp.datatype = "port"
tp.default = "5055"

local did = s:option(Value, "device_id", translate("Device ID"), translate("IMEI / unique id of this gateway as registered in TARGTEC TrackMap"))
did.placeholder = "e.g. 868000000000000"

return m
