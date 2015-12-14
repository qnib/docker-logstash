import zmq
context = zmq.Context()
consumer_receiver = context.socket(zmq.REP)
consumer_receiver.bind("tcp://0.0.0.0:5557")
while True:
    work = consumer_receiver.recv_json()
    print work
    consumer_receiver.send_json(work)
