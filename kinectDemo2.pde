/* --------------------------------------------------------------------------
 * SimpleOpenNI DepthMap3d Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 * date:  02/16/2011 (m/d/y)
 * ----------------------------------------------------------------------------
 */
 
 // Commented for Designing with Depth at interaccess by Andrew Lovett-Barron
import SimpleOpenNI.*;

SimpleOpenNI context;

// Declare variables we'll need to work with some 
float        zoomF =0.3f;
float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
                                   // the data from openni comes upside down
float        rotY = radians(0);

void setup()
{
   frameRate(30);
 
  size(1024,768,P3D);
  context = new SimpleOpenNI(this);

  // Mirroring flips the image, providing a shortcut for dealing
  // with the image data we get back, which is normally reversed.
  context.setMirror(true);

  // This is a debugging trick. It allows you to attempt to define a context,
  // such as saying "Alright, I want to get the depth image," and returning 
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }

  stroke(255,255,255);
  smooth();
  // Perspective is a fun function. It lets us define the field of view
  // (45 degrees in this case), the aspect ratio (width/height),
  // the near field in "points" on the depth plane, and the far field in
  // points on the depth plane.
  perspective(radians(45),
              float(width)/float(height),
              10,150000);
}

void draw()
{
  // update the cam like in the previous sketch
  context.update();

  // We want to clear the background in order to draw on top of it.
  // If we don't do this, it will retain the previous image and we'll get
  // a kind of drag effect. Clearing a screen or canvas is an important
  // concept when dealing with this type of programming, and gets even
  // crazier when you get into openGL.
  background(0,0,0);

  // We move the entire screen to being half the width and half the height
  // of the screen. This centers the view port on the center of our 3D world.
  // All points in this world have three values: their x, y, and z positions.
  // The center of this world has an x of zero, a y of zero, and a z of zero.
  translate(width/2, height/2, 0);
  // These transform our perspective based on the input values: rotation + scale.
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);


  // Alright, let's transfer our depth map into an integer array. This gives us
  // a set of values that we can directly work with.
  int[]   depthMap = context.depthMap();
  // This is like a skip or step number, which we see in the loop below.
  int     steps   = 3;
  int     index;
  PVector realWorldPoint;
  
  // set the rotation center of the scene 1000 infront of the camera
  translate(0,0,-1000);

  stroke(255);

  // We create a real world map of our points. This means that we have a set
  // of datapoints that have been heavily processed to remove things like
  // camera or lens distortion, and are ready to be translated and projected
  // into 3D space.
  PVector[] realWorldMap = context.depthMapRealWorld();
  
  // This is the golden part.
  // We want to take the large array of numbers that we have, and parse
  // through each one. So we know that there is a width and height to each
  // depth image, and our real world depth map is just a list of numbers.
  // The way we make sense of these numbers is by understanding where each one
  // becomes a new line, so if an image is 300 pixels wide, we know that
  // every 300 pixels we need to start a new line. The code below is how we
  // make sense of that.
  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      // Our index tells us where we need to be in our array. We perform this
      // calculation by multiplying y by the width of the image we get back,
      // basically saying "Okay, how many rows down do we need to go?"
      // and then adding which pixel on the following row we want.
      index = x + y * context.depthWidth();
      
      // this is just a check to make sure we aren't going to 
      // return an empty value. This can crash our program if we do.
      if(depthMap[index] > 0)
      { 
        // Here we assign the converted point to a variable, and draw it.
        // A potential shortcut for this can be 
        // realWorldPoint = context.depthMapRealWorld()[index];
        realWorldPoint = realWorldMap[index];
        // This is the actual function, point() that draws the point in space.
        // Because realWorldPoint is a PVector type object, is has fields
        // called x, y, and z. It also has a number of methods that can be used
        // to do more complex calculations on it, I recommend you give it a look!
        // http://processing.org/reference/PVector.html
        point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);  // make realworld z negative, in the 3d drawing coordsystem +z points in the direction of the eye
      }
    }
  } 

  // draw the kinect camera for reference, this is a method provided by the
  // OpenNI package.
  context.drawCamFrustum();
}

// We can work with keyboard pressed by using the void keyPressed() function,
// which is running in the background and responds every time we press a key.
void keyPressed()
{
  // The switch statement works by addressing a variable with many different
  // states.
  switch(key)
  {
    // It does this by declaring "cases" for a particular set of actions,
    // so in the event of a space, we want to mirror the image.
  case ' ':
    context.setMirror(!context.mirror());
    // You always have to leave a case by stating "break;"
    break;
  }

  switch(keyCode)
  {
  case LEFT:
    rotY += 0.1f;
    break;
  case RIGHT:
    // zoom out
    rotY -= 0.1f;
    break;
  case UP:
    if(keyEvent.isShiftDown())
      zoomF += 0.02f;
    else
      rotX += 0.1f;
    break;
  case DOWN:
    if(keyEvent.isShiftDown())
    {
      zoomF -= 0.02f;
      if(zoomF < 0.01)
        zoomF = 0.01;
    }
    else
      rotX -= 0.1f;
    break;
  }
}

