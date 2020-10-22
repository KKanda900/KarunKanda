# GUI application for IEEE Competition
from tkinter import *
import socket
import sys
import csv
from pymavlink import mavutil
import webbrowser
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt

top = tkinter.Tk()
top.title('BlueROV GUI')

master = mavutil.mavlink_connection('udpin:0.0.0.0:14550') 

# Here we can place the functions for data we need for the robot
def instructions():
    tkMessageBox.showinfo("Instructions", "Click on the button corresponding to data or an action")

def recieving():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    IP_ADDR = '192.168.2.1'
    # Connect the socket to the port on the server given by the caller
    server_address = (IP_ADDR, 10000)
    print >>sys.stderr, 'connecting to %s port %s' % server_address
    sock.connect(server_address)
    try:
        message = 'This is the message.  It will be repeated.'
        print >>sys.stderr, 'sending "%s"' % message
        sock.sendall(message)
        amount_received = 0
        amount_expected = len(message)
        while amount_received < amount_expected:
            data = sock.recv(16)
            amount_received += len(data)
            print >>sys.stderr, 'received "%s"' % data
    finally:
        sock.close()

def mapPlot():
    m = Basemap(projection='mill', llcrnrlat = -75.5, llcrnrlon = 38.92, urcrnrlat= -73.8442, urcrnrlon = 41.382, resolution = 'l')
    fig, ax = plt.subplots(figsize=(10,20))
    m.drawcoastlines()
    m.drawcountries (linewidth=2)
    m.drawstates(color='b')
    m.bluemarble()
    
    plt.title('World Pollution Map')
    plt.show()

def getIMU():
    msg = master.recv_match(type='SCALED_IMU2', blocking=True)
    return msg.xacc

def retrieveIMU():
    # Create a TCP/IP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # Bind the socket to the address given on the command line
    server_name = '192.168.2.4'
    server_address = (server_name, 10000)
    print >>sys.stderr, 'starting up on %s port %s' % server_address
    sock.bind(server_address)
    sock.listen(1)
    while True:
        print >>sys.stderr, 'waiting for a connection'
        connection, client_address = sock.accept()
        try:
            print >>sys.stderr, 'client connected:', client_address
            while True:
                data = connection.recv(16)
                print >>sys.stderr, 'received "%s"' % data
                if data:
                    connection.sendall(data)
                else:
                    break
        finally:
            connection.close()

def getTemp():
    return 0

def getPressure():
    return 0

def get02():
    return 0

A = Tkinter.Button(top, text = "How to use BlueROV GUI", command = instructions)
B = Tkinter.Button(top, text = "IMU", command = retrieveIMU)
C = Tkinter.Button(top, text = "Temperature", command = getTemp)
D = Tkinter.Button(top, text = "Pressure", command = getPressure)
E = Tkinter.Button(top, text = "O2 Levels", command = get02)
F = Tkinter.Button(top, text = "Pin GPS Location", command = mapPlot)


A.pack(side = "top")
B.pack(side = "left")
C.pack(side = "left")
D.pack(side = "left")
E.pack(side = "left")
F.pack(side = "bottom")
top.mainloop()

'''
This has to be included in every function to work
# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
IP_ADDR = '192.168.42.1'
# Connect the socket to the port on the server given by the caller
server_address = (IP_ADDR, 10000)
print >>sys.stderr, 'connecting to %s port %s' % server_address
sock.connect(server_address)
try:
    
    message = 'This is the message.  It will be repeated.'
    print >>sys.stderr, 'sending "%s"' % message
    sock.sendall(message)
    amount_received = 0
    amount_expected = len(message)
    while amount_received < amount_expected:
        data = sock.recv(16)
        amount_received += len(data)
        print >>sys.stderr, 'received "%s"' % data
finally:
    sock.close()
'''