# Karun Kanda
# CPS Lab
from math import *
from multiprocessing import Process
from pymavlink import mavutil
import time

master = mavutil.mavlink_connection('udpin:0.0.0.0:14550')
print('Waiting for Heartbeat')
master.wait_heartbeat()
print "Heartbeat Detected"
master.arducopter_arm()
print "BlueROV Armed"

def set_rc_channel_pwm( channel, pwm=1500):
    if channel < 1:
        print("Channel does not exist.")
        return
    if channel < 9:
        rc_channel_values = [65535 for _ in range(8)]
        rc_channel_values[channel - 1] = pwm
        master.mav.rc_channels_override_send(
            master.target_system,  # target_system
            master.target_component,  # target_component
            *rc_channel_values)  # RC channel list, in microseconds.

def setNeutral():
    set_rc_channel_pwm(1, 1500)
    set_rc_channel_pwm(2, 1500)
    set_rc_channel_pwm(3, 1500)
    set_rc_channel_pwm(4, 1500)
    set_rc_channel_pwm(5, 1500)
    set_rc_channel_pwm(6, 1500)
    return

def getLatestHeading():
    msg = master.recv_match(type='VFR_HUD', blocking=True)
    return msg.heading

def angleDiff(setPoint, currentHeading):
    deltaAngle = setPoint - currentHeading
    deltaAngle = (deltaAngle + 180) % 360 - 180
    return deltaAngle

def errorAttitude(setPoint, currentAtt):
    error = setPoint - currentAtt
    return error

def getCurrGPS():
    msg = master.recv_match(type='GPS_RAW_INT', blocking=True)
    return msg.lat/10000000.0, msg.lon/10000000.0

def turn(degrees):
    master.arducopter_arm()
    heading = getLatestHeading()
    targetHeading = heading + degrees
    if targetHeading > 360:
        targetHeading = targetHeading - 360
    deltaAngle = angleDiff(heading, targetHeading)
    while deltaAngle not in range(-1, 2):
        if degrees > 0:
            if abs(deltaAngle) >= 90:
                set_rc_channel_pwm(4, 1600)
            elif abs(deltaAngle) in range(45, 90):
                set_rc_channel_pwm(4, 1580)
            elif abs(deltaAngle) in range(19, 45):
                set_rc_channel_pwm(4, 1560)
            elif abs(deltaAngle) in range(0, 19):
                set_rc_channel_pwm(4, 1550)
            else:
                set_rc_channel_pwm(4, 1550)
        else:
            if abs(deltaAngle) >= 90:
                set_rc_channel_pwm(4, 1400)
            elif abs(deltaAngle) in range(45, 90):
                set_rc_channel_pwm(4, 1420)
            elif abs(deltaAngle) in range(19, 45):
                set_rc_channel_pwm(4, 1440)
            elif abs(deltaAngle) in range(0, 19):
                set_rc_channel_pwm(4, 1450)
            else:
                set_rc_channel_pwm(4, 1550)
        deltaAngle = angleDiff(getLatestHeading(), targetHeading)
    print("Turn Complete")
    return


def bearAngle():
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    Bearing = atan2(cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(lon2-lon1), sin(lon2-lon1)*cos(lat2))
    heading = getLatestHeading()
    Bearing = 90-degrees(Bearing)
    return Bearing


def turningNorth():
    heading = getLatestHeading()
    targetHeading = 0
    deltaAngle = angleDiff(targetHeading, heading)  
    return deltaAngle


def haversine(lon1, lat1, lon2, lat2):
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))
    r = 6371
    return c * r

def getLatestAtt():
    msg = master.recv_match(type='ATTITUDE', blocking=True)
    return msg.yaw

def forwardPID(speed, KP, KI, KD, duration):
    lastError = 0
    integral = 0
    iteration_time = 0.01
    lateralSpeed = 1500
    setPoint = getLatestAtt()
    set_rc_channel_pwm(5, speed)
    endTime = time.time() + duration  # Seconds
    iniheading = getLatestHeading()
    while time.time() <= endTime:
        currentHeading = getLatestHeading()
        if iniheading != currentHeading:
            print "adjusting"
            deltaAngle = bearing - iniheading
            deltaAngle = int(deltaAngle)
            turn(deltaAngle)
        lateralSpeed = int(lateralSpeed)
        if lateralSpeed < 1450:
            lateralSpeed = 1450
        elif lateralSpeed > 1550:
            lateralSpeed = 1550
        set_rc_channel_pwm(4, lateralSpeed)
    return

# Main Function:
print('Current GPS Location: ')
lat1, lon1 = getCurrGPS()
print("Latitude: %f" % lat1, "Longitude: %f" % lon1)
lat1 = radians(lat1)
lon1 = radians(lon1)
print('Enter destination GPS Coordinates')
# Right side of the canal
lat2 = float(raw_input("Enter the destination's latitude: ")
lon2 = float(raw_input("Enter the destination's longitude: ")
print ("Destination Latitude: %f" % lat2, "Longitude: %f" % lon2)
lat2 = radians(lat2)
lon2 = radians(lon2)
print('Guided Path Started')
heading = getLatestHeading()
bearing = bearAngle()
deltaAngle = bearing - heading
deltaAngle = int(deltaAngle)
print("Bearing: %d " % bearing)
print('Turning Towards Destination')
turn(deltaAngle)
print('Going to Destination')
dist = haversine(lon1, lat1, lon2, lat2)*1000
print("Distance to destination: %d" % dist)
# allow 1 meter error
start_time = time.time() + 5
while dist not in range(-3,2):
    set_rc_channel_pwm(6,1650)
    lat1, lon1 = getCurrGPS() 
    dist = haversine(radians(lon1), radians(lat1), lon2, lat2)*1000
    print dist
    if iniheading != currHeading:
        print('Adjusting')
        deltaAngle = bearing - heading
        deltaAngle = int(deltaAngle)
        print('Turning back towards destination')
        turn(deltaAngle)
'''
Another another implementation:
start.time() = 0
    if time.time() - start.time() % 5 == 0:
      print "adjusting"
      heading = getLatestHeading()
      lat1, lon1 = getCurrGPS()
      bearing = bearAngle()
      deltaAngle = bearing - heading
      deltaAngle = int(deltaAngle)
      start_time += 5
      if not deltaAngle == 0:
        print("Bearing: %d " % bearing)
        print('Turning Towards Destination')
        turn(deltaAngle)
      print('Going to Destination')
'''   
print('Disarming BlueROV')
master.arducopter_disarm()
print('BlueROV disarmed')
print('Guided Path Ended')