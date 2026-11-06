
-- TARGTEC: the IVMS LoRa gateway (the LoRa bin / E32 trackers), appended to Sensor > LoRa / LoRaWAN.
m2 = Map("ivmslora", translate("IVMS LoRa gateway (E32 on USB)"),
	translate("Answers the IVMS LoRa trackers (the LoRa bin) through an Ebyte E32 on a USB-serial adapter in this gateway's USB port. " ..
	"Configure the E32 exactly like the trackers' (same ADDR, CHAN and air rate, UART 9600 8N1, transparent, M0=M1=GND). " ..
	"The built-in radio above is not used for these trackers: the E32 uses its own framing, which this radio cannot decode."))

local g = m2:section(NamedSection, "general", "settings", translate("Gateway"))
local en = g:option(Flag, "enabled", translate("Enable"))
en.rmempty = false

local p = g:option(Value, "port", translate("Serial port"), translate("CH340 / CP2102 / FTDI / PL2303 adapters appear as /dev/ttyUSB0"))
p.default = "/dev/ttyUSB0"
p:value("/dev/ttyUSB0"); p:value("/dev/ttyUSB1"); p:value("/dev/ttyACM0")

local b = g:option(ListValue, "baud", translate("Baud rate"))
b:value("9600"); b:value("19200"); b:value("38400"); b:value("57600"); b:value("115200")
b.default = "9600"

local a = g:option(Value, "api", translate("TARGTEC API"))
a.default = "https://api.targtec.com"

local u = g:option(Value, "unit_id", translate("Gateway unit id"), translate("From TARGTEC: SMS gateway units (a unit for this gateway)"))
u.datatype = "uinteger"

local s = g:option(Value, "secret", translate("Gateway unit secret"))
s.password = true

local po = g:option(Value, "poll", translate("Job poll (s)"))
po.datatype = "range(3,60)"
po.default = "5"

function m2.on_after_commit(self)
	luci.sys.call("/etc/init.d/ivmslora enable >/dev/null 2>&1; /etc/init.d/ivmslora restart >/dev/null 2>&1")
end
