# Designing with Depth Kinect Workshop
### July 12, 2012 
*Taught by (Andrew Lovett-Barron)[http://readywater.ca]
at (Interaccess Electronic media arts center)[http://interaccess.org]*

### Intro to Kinect
#### What is it?
Kinect as a 3D camera
Kinect as eyes for a computer
Kinect as a sensor
How does a 3d camera work?
Infrared sensor
Use example of depthInfrared
Mapping and projection
Seeing in depth vs. seeing in colour
Problems of computer vision
Triage of visual information in colour

#### Why is the Kinect important?
The kinect lets your computer see.
First cheap, accessible, and widely popular computer vision tool.
Makes things possible that were previously only possible to labs and Ph.Ds
Some examples: robotic vision, 3D scanning, 

### Post-hack Kinect
Dabbling to mastery
Experimentation with point aesthetics
OpenCV and introduction
	
### Kinect
- Simplicity of the device
- Kinect with Robots
- Kinect for interaction
- Kinect in architectural or ambient interaction

### OpenCV
####Tools
Kyle McDonald's FaceOSC: https://github.com/kylemcdonald/ofxFaceTracker/downloads
(Use with http://www.osculator.net/ and whatever uses openSoundControl)

####What is an image?
An image is an array of numerical values
How we see an image
```
[0 ][1 ][2 ][3 ]
[4 ][5 ][6 ][7 ]
[8 ][9 ][10][11]
[12][13][14][15]
```

How a computer sees that image
```
[0 ][1 ][2 ][3 ][4 ][5 ][6 ][7 ][8 ][9 ][10][11][12][13][14][15]
```
We work with this data by creating loops and interating over them in order to understand WHERE to make breaks in the otherwise continuous line.
```java
for( int y=0; y< image.height; y++) {
	for( int x=0; x< image.width; x++) {
		arrayIndex = x + (y * image.width);
		doSomethingToExactPixel(image[arrayIndex]);
	}
}
```
Super good tutorial on learning how to deal with images:
http://processing.org/learning/pixels/

- Features and tracking
Face
Hand tracking
Idea of HAAR cascades

### Depth Sensors/cameras as part of a broader ecosystem 
Visual tagging of sensor objects (infrared PWM)
Rapid markup and modeling of a space
Augmented Reality and semantic tagging



### OpenNI and coding for the Kinect
- Let's install
http://code.google.com/p/simple-openni/downloads/list?can=2&q=Installer+osx

The openNI toolkit offers a really quick and easy install for OSX. This comes in the form of a shell script, basically a set of terminal commands, that copies the different files you need into their appropriate place.

Run this by typing sudo ./install.sh in the folder.
I have a tutorial for doing stuff in the command line here if this is confusing!
http://readywater.ca/commandline.html

- Processing
Have Processing installed.
Need ~/Documents/Processing/libraries/
copy simpleOpenNI into your libraries folder
Restart processing if it's open

- Testing it out and explaining the first demo

All demos are heavily commented demos from the SimpleOpenNI toolkit by Max Rheiner http://iad.zhdk.ch/
http://code.google.com/p/simple-openni

(Demo 1: Basic Kinect, getting an image)

(Demo 2: Point clouds and 3D space)

(Demo 3: User tracking with openNI)