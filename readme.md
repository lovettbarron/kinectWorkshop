# Designing with Depth Kinect Workshop
## July 12, 2012 

	(First part of class should run about 1h30m)
# Intro to Kinect
## 20 minutes
- What is it?
> Kinect as a 3D camera
> Kinect as eyes for a computer
> Kinect as a sensor
- How does a 3d camera work?
> Infrared sensor
> > Use example of depthInfrared
> Mapping and projection
> Seeing in depth vs. seeing in colour
> > Problems of computer vision
> > Triage of visual information in colour
- Why is the Kinect important?
> The kinect lets your computer see.
> First cheap, accessible, and widely popular computer vision tool.
> Makes things possible that were previously only possible to labs and Ph.Ds
> Some examples: robotic vision, 3D scanning, 

# Post-hack Kinect
## 10 minutes
- Dabbling to mastery
- Experimentation with point aesthetics
- OpenCV and introduction
	
# Kinect
## 20 minutes
- Simplicity of the device
- Kinect with Robots
- Kinect for interaction
- Kinect in architectural or ambient interaction

# OpenCV
## 20 minutes
- Tools
Kyle McDonald's FaceOSC
> https://github.com/kylemcdonald/ofxFaceTracker/downloads
> (Use with http://www.osculator.net/ and whatever uses openSoundControl)



- What is an image?
An image is a calculation, an array of numerical values
Regions of interest and proggressive manipulation
- Features and tracking
> Face tracking
> Hand tracking
> Idea of HAAR cascades
- Flow and movement


# Depth Sensors/cameras as part of a broader ecosystem 
## (20 minutes)
Visual tagging of sensor objects (infrared PWM)
Rapid markup and modeling of a space
Augmented Reality and semantic tagging


(Second part of class should run about 1h 30min to 2h)
# OpenNI and coding for the Kinect
- Let's install
http://code.google.com/p/simple-openni/downloads/list?can=2&q=Installer+osx
The openNI toolkit offers a really quick and easy install for OSX. This comes in the form of a shell script, basically a set of terminal commands, that copies the different files you need into their appropriate place.
Run this by typing sudo ./install.sh in the folder.

- Processing
Have Processing installed.
Need ~/Documents/Processing/libraries/
copy simpleOpenNI into your libraries folder
Restart processing if it's open

- Testing it out and explaining the first demo

All demos are heavily commented demos from the SimpleOpenNI toolkit by Max Rheiner http://iad.zhdk.ch/
http://code.google.com/p/simple-openni

Demo 1: Basic Kinect, getting an image
Demo 2: Point clouds and 3D space
Demo 3: User tracking with openNI