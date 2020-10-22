import socket 
import pickle #specific python object
from _thread import *
import threading

HEADERSIZE = 10
print_lock = threading.Lock()

def threaded(c):
    while True:
        data = c.recv(1024)
        if not data:
            print('Bye')

            print_lock.release()
            break

        d = {1: "Hey", 2: "There"}
        msg = pickle.dumps(d)
        print(msg)
        msg = bytes(f'{len(msg):<{HEADERSIZE}}', "utf-8") + msg
        c.send(msg)


def Main():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((socket.gethostname(), 1234))
    print("Socket is listening")
    s.listen(5)

    while True:
        client, address = s.accept()
        print_lock.acquire()
        print('Connected to :', address[0], ':', address[1]) 
        start_new_thread(threaded, (client,))
    client.close()



if __name__ == "__main__":
    Main()