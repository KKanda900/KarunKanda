import os
import argparse
import cv2
import numpy as np
import sys
import time
from threading import Thread
import importlib.util
import Camera # VideoStream Class

# Next task: Create the pollution detection model

# Input Arguments
parser = argparse.ArgumentParser()
parser.add_argument('--modelpath', help='Folder the .tflite file is located in', required=True)
parser.add_argument('--graph', help='Name of the .tflite file, if different than detect.tflite', default='detect.tflite')
parser.add_argument('--labels', help='Name of the labelmap file, if different than labelmap.txt', default='labelmap.txt')

# Take the input arguments and parse them to use them in the rest of the script
args = parser.parse_args()
MODEL_NAME = args.modelpath
GRAPH_NAME = args.graph
LABELMAP_NAME = args.labels
min_conf_threshold = 0.5 # won't go higher than 0.5
imW, imH = 640, 480
use_TPU = False # usb accelerator

pkg = importlib.util.find_spec('tflite_runtime')
if pkg:
    from tflite_runtime.interpreter import Interpreter
    if use_TPU:
        from tflite_runtime.interpreter import load_delegate
else:
    from tensorflow.lite.python.interpreter import Interpreter
    if use_TPU:
        from tensorflow.lite.python.interpreter import load_delegate

CWD_PATH = os.getcwd()
PATH_TO_CKPT = os.path.join(CWD_PATH,MODEL_NAME,GRAPH_NAME)
PATH_TO_LABELS = os.path.join(CWD_PATH,MODEL_NAME,LABELMAP_NAME)

with open(PATH_TO_LABELS, 'r') as f:
    labels = [line.strip() for line in f.readlines()]

if labels[0] == '???': # deletes the ??? from the label generation
    del(labels[0])

interpreter = Interpreter(model_path=PATH_TO_CKPT)    
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
height = input_details[0]['shape'][1]
width = input_details[0]['shape'][2]

floating_model = (input_details[0]['dtype'] == np.float32)
input_mean = 127.5
input_std = 127.5

videostream = Camera.VideoStream(resolution=(imW,imH),framerate=60).start()
time.sleep(0.88)

while True:

    frame1 = videostream.read()

    frame = frame1.copy()
    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    frame_resized = cv2.resize(frame_rgb, (width, height))
    input_data = np.expand_dims(frame_resized, axis=0)

    if floating_model:
        input_data = (np.float32(input_data) - input_mean) / input_std

    interpreter.set_tensor(input_details[0]['index'],input_data)
    interpreter.invoke()

    # Creates the boxes that will be used when detecting the objects
    boxes = interpreter.get_tensor(output_details[0]['index'])[0] # Bounding box coordinates of detected objects
    classes = interpreter.get_tensor(output_details[1]['index'])[0] # Class index of detected objects
    scores = interpreter.get_tensor(output_details[2]['index'])[0] # Confidence of detected objects

    for i in range(len(scores)):
        if ((scores[i] > min_conf_threshold) and (scores[i] <= 1.0)): # Object is detected within the minimum confidence level

            ymin = int(max(1,(boxes[i][0] * imH)))
            xmin = int(max(1,(boxes[i][1] * imW)))
            ymax = int(min(imH,(boxes[i][2] * imH)))
            xmax = int(min(imW,(boxes[i][3] * imW)))
            
            cv2.rectangle(frame, (xmin,ymin), (xmax,ymax), (10, 255, 0), 2)

            object_name = labels[int(classes[i])] 
            label = '%s: %d%%' % (object_name, int(scores[i]*100)) # Object name (label) with the level of confidence (>0.5)
            labelSize, baseLine = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.7, 2)
            label_ymin = max(ymin, labelSize[1] + 10)
            cv2.rectangle(frame, (xmin, label_ymin-labelSize[1]-10), (xmin+labelSize[0], label_ymin+baseLine-10), (255, 255, 255), cv2.FILLED) 
            cv2.putText(frame, label, (xmin, label_ymin-7), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 0), 2)

    cv2.imshow('Pollution Detection', frame)

    if cv2.waitKey(1) == 27:
        print("Exiting...")
        break

cv2.destroyAllWindows()
videostream.stop()