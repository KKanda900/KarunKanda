#TCP based Sockets

import socket
import select #os level capabilities

#Global Definitions:
HEADER_LENGTH = 10 # size of message which we keep at 10

def recieve_message(client):
    message_header = client.recv(HEADER_LENGTH)

    if not len(message_header):
        return False
        
    message_length = int(message_header.decode("utf-8").strip())
    return {"header": message_header, "data": client.recv(message_length)}


def Main():
    s_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    s_socket.bind((socket.gethostname(), 1234))
    print("Socket listening...")
    s_socket.listen()

    s_list = [s_socket] # list of sockets

    c = {} # list of clients

    while True:
        read_sockets, _, exception_sockets = select.select(s_list, [], s_list)

        for notified_socket in read_sockets:
            if notified_socket == s_socket:
                clients_socket, client_address = s_socket.accept()

                user = recieve_message(clients_socket) #JSON script that has data and header
                if user is False:
                    continue

                s_list.append(clients_socket)

                c[clients_socket] = user

                print(f"New connection from {client_address[0]}:{client_address[1]} username:{user['data'].decode('utf-8')}")
            
            else:
                message = recieve_message(notified_socket)

                if message is False:
                    print(f"Closed connection from {c[notified_socket]['data'].decode('utf-8')}")
                    s_list.remove(notified_socket)
                    del c[notified_socket]
                    continue
                
                user = c[notified_socket]
                print(f"Recieved message from {user['data'].decode('utf-8')}: {message['data'].decode('utf-8')}")

                for clients_socket in c:
                    if clients_socket != notified_socket:
                        clients_socket.send(user['header'] + user['data'] + message['header'] + message['data'])

        for notified_socket in exception_sockets:
            s_list.remove(notified_socket)
            del c[notified_socket]


if __name__ == "__main__":
    Main()

