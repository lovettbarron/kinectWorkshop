// This demo is from the openNI site, 
// http://code.google.com/p/simple-openni/


// Imports the library, which should be at
// ~/Documents/Processing/libraries/SimpleOpenNI
import SimpleOpenNI.*;

// Declare the openNI class, calling it Context
SimpleOpenNI  context;
/*
 In Processing, we have two key functions. 
 The Setup() loop is run once, and is where you define everything
 you need to run in the program. This includes defining your
variables, setting up the environment, and creating data
*/
void setup()
{
  // We instantiate the openNI object using "new." This means that
  // we declare that "context" is a new instance of "SimpleOpenNI"
  context = new SimpleOpenNI(this);
   
  // enable depthMap generation, meaning we get this
  // data from the kinect 
  context.enableDepth();
  
  // enable camera image generation, which uses the colour
  // camera to give us an image as well
  context.enableRGB();

  // We make our background red for debugging
  background(200,0,0);
  // We define the width of the screen by getting the width
  // of the two data feeds, and the height be getting the RGB height)
  size(context.depthWidth() + context.rgbWidth() + 10, 
  context.rgbHeight()); 
}

/*
The second important function in processing is the draw() loop,
which is run once per frame to perform calculations and draw the image.
*/
void draw()
{
  // We need to specifically request data from the
  // openNI toolkit and Kinect for every frame. This way, we
  // can limit the amount of data we're getting, or define the
  // exact speed we want it at, such as by using frameRate(30) for
  // 30 frames per second.
  context.update();
  
  // We draw the depth map using "Image," and place it at the
  // top left hand corner
  image(context.depthImage(),0,0);
  
  // We draw the RGB image at the top right hand corner.
  image(context.rgbImage(),context.depthWidth() + 10,0);
}
