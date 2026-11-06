#!/bin/sh

# Send a GPS fix to the configured GPS Track Server (Sensor > GPS Track Server).
#   gpswox  : http://<server>/insert.php?user_api_hash=...   (unchanged Dragino behaviour)
#   targtec : OsmAnd protocol  http://<server>:<port>/?id=<device_id>&lat=&lon=&timestamp=&speed=&altitude=&bearing=&batt=
#
# Usage: send_gps_data.sh -d deviceId -l latitude -n longitude -a altitude [-s speed] [-c course] [-b battery]

while getopts 'd:l:n:a:s:c:b:h:' OPTION
do
	case $OPTION in
	d)	uniqueID="$OPTARG"
		;;
	l)	latitude="$OPTARG"
		;;
	n)	longitude="$OPTARG"
		;;
	a)	altitude="$OPTARG"
		;;
	s)	speed="$OPTARG"
		;;
	c)	course="$OPTARG"
		;;
	b)  battery="$OPTARG"
		;;
	h|?)	printf "Send gps data to the GPS Track Server \n\n"
		printf "Usage: %s -d devicdId -l latitude -n logitude -a altitude \n" $(basename $0) >&2
		printf "       -d: deviceID\n"
		printf "       -l: latitude xx.xxxxxx\n"
		printf "       -n: longitude xx.xxxxxx\n"
		printf "       -a: altitude\n"
		printf "       -s: speed\n"
		printf "       -c: course\n"
		printf "       -b: battery\n"
		printf "\n"
		exit 1
		;;
	esac
done

([ -z "$uniqueID" ] || [ -z "$latitude" ] || [ -z "$longitude" ] || [ -z "$altitude" ]) && exit 1

[ -z "$battery" ] && battery=0
[ -z "$speed" ] && speed=0
[ -z "$course" ] && course=0

service=`uci -q get gpstrack.general.gps_service`

if [ "$service" = "targtec" ]; then
	server=`uci -q get gpstrack.targtec.server`
	port=`uci -q get gpstrack.targtec.port`
	dev=`uci -q get gpstrack.targtec.device_id`
	[ -z "$server" ] && server="track.targtec.com"
	[ -z "$port" ] && port=5055
	[ -z "$dev" ] && dev="$uniqueID"
	ts=`date +%s`
	url="http://$server:$port/?id=$dev&lat=$latitude&lon=$longitude&timestamp=$ts&speed=$speed&altitude=$altitude&bearing=$course&batt=$battery"
	[ "`uci -q get iot-services.general.debug`" != "0" ] && logger "[IoT.GPS]: TARGTEC $url"
	curl -s -m 15 "$url" > /dev/null
	exit $?
fi

if [ "$service" = "disabled" ] || [ -z "$service" ]; then
	exit 0
fi

##make sure always has api_hash
/usr/bin/get_gpswox_api_hash.sh

## gpswox tracking server
ip=`uci get gpstrack.gpswox.server`
user_api_hash=`uci get gpstrack.gpswox.user_api_hash`

## {"battery":"0%"} ##
attributes="7B%22battery%22:%22$battery22%7D"

fixTime=`date +%s`"000"

data="?user_api_hash=$user_api_hash&fixTime=$fixTime&valid=1&uniqueId=$uniqueID&latitude=$latitude&longitude=$longitude&attributes=$attributes&speed=$speed&altitude=$altitude&course=$course&protocol=iOS"

req="http://$ip/insert.php"

curl --user-agent "GPS%20Tracker/1.0 CFNetwork/811.5.4 Darwin/16.6.0" "$req$data"

exit 0
