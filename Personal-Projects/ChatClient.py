#TCP based Sockets

import socket
import select
import errno
import sys

#Global Definitions:
HEADER_LENGTH = 10

def Main():
    
    my_username = input("Enter your Username: ")
    c_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    c_socket.connect((socket.gethostname(), 1234))
    c_socket.setblocking(False)

    username = my_username.encode('utf-8')
    username_header = f"{len(username):<{HEADER_LENGTH}}".encode('utf-8')
    c_socket.send(username_header + username)

    while True:
        message = input(f"{my_username} > ")

        if message:
            message = message.encode('utf-8')
            message_header = f"{len(message):<{HEADER_LENGTH}}".encode('utf-8')
            c_socket.send(message_header + message)
        
        try:
            while True:
                # recieve portion
                username_header = c_socket.recv(HEADER_LENGTH)
                if not len(username_header):
                    print("Connection closed by the Server")
                    sys.exit()
                
                username_length = int(username_header.decode('utf-8').strip())
                username = c_socket.recv(username_length).decode('utf-8')

                message_header = c_socket.recv(HEADER_LENGTH)
                message_length = int(message_header.decode('utf-8').strip())
                message = c_socket.recv(message_length).decode('utf-8')

                print(f"{username} > {message}")
        
        except IOError as e:
            if e.errno != errno.EAGAIN and e.errno != errno.EWOULDBLOCK:
                print('reading error', str(e))
                sys.exit()
            continue


        except Exception as e:
            print('General Error', str(e))
            sys.exit()
            


if __name__ == "__main__":
    Main()
