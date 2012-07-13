/* --------------------------------------------------------------------------
 * SimpleOpenNI User3d Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 * date:  02/16/2011 (m/d/y)
 * ----------------------------------------------------------------------------
 * this demos is at the moment only for 1 user, will be implemented later
 * ----------------------------------------------------------------------------
 */
 // Commented for Kinect class at Interaccess by Andrew Lovett-Barron
 
import SimpleOpenNI.*;


SimpleOpenNI context;

float        zoomF =0.5f;
float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
                                   // the data from openni comes upside down
float        rotY = radians(0);
boolean      autoCalib=true;

PVector      bodyCenter = new PVector();
PVector      bodyDir = new PVector();

void setup()
{
  size(1024,768,P3D);
  context = new SimpleOpenNI(this);
  context.setMirror(true);
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }

  // enable skeleton generation for all joints
  // This is a flag that we send to the openNI software, saying that
  // we want it to try and track users. It's important to only turn this
  // on when you really want it, as skeleton tracking is a very intensive process.
  // The second thing you might notice about this is the argument inside the
  // function, saying 'SimpleOpenNI.SKEL_PROFILE_ALL'
  // This just tells the user tracking system to look for the full body, not
  // just the head and hands, for example. For head and hands, you would write
  // context.enableUser(SimpleOpenNI.SKEL_PROFILE_HEAD_HANDS);
  // The full list of arguments can be viewed here: 
  // http://simple-openni.googlecode.com/svn/trunk/SimpleOpenNI/dist/all/SimpleOpenNI/documentation/SimpleOpenNI/SimpleOpenNIConstants.html#SKEL_PROFILE_ALL
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  stroke(255,255,255);
  smooth();  
  perspective(radians(45),
              float(width)/float(height),
              10,150000);
 }

void draw()
{
  context.update();

  background(0,0,0);
  
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  
  int[]   depthMap = context.depthMap();
  int     steps   = 3;  // to speed up the drawing, draw every third point
  int     index;
  PVector realWorldPoint;
 
  translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera

  stroke(100); 
  // We're going to draw all the points on the screen to 
  // use for debugging purposes. This is especially helpful
  // in a 3D environment, where things can get weird.
  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      if(depthMap[index] > 0)
      { 
        // draw the projected point
        realWorldPoint = context.depthMapRealWorld()[index];
        point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);
      }
    } 
  } 
  
  // This is where we get the list of users.
  // OpenNI is able to track multiple users at a time, so when we
  // ask openNI for the list of currently tracked users, we assign
  // its response to an array of integers, which hold these users' IDs.
  int[] userList = context.getUsers();
  
  // Next, since we're in the draw loop, we go through this list of users
  // and draw the skeletons that are being tracked on the screen.
  for(int i=0;i<userList.length;i++)
  {
    // First, we make sure that the ID is still being tracked
    if(context.isTrackingSkeleton(userList[i]))
      // And then we draw the skeleton, using a function we've declared
      // called DrawSkeleton.
      drawSkeleton(userList[i]);
  }    
 
  context.drawCamFrustum();
}

// Drawing the skeleton involves quite a bit. That's why we've seperated
// all this complexity off into a separate function. The drawSkeleton function
// takes its only argument as the users' ID number, which can be used to
// call and identify the different parts of the skeleton that need to be drawn.
void drawSkeleton(int userId)
{
  // Since we're drawing, we want to define a particular weight to the drawing
  strokeWeight(3);

  // What's this, more functions? The draw limb functino is something that
  // we've declared ourselves later. Our programs can get very complicated
  // very quickly, and there are a couple of ways of dealing with this
  // this. Here, we're showing how to deal with complexity through functional
  // programming. This means that different actions and interactions within
  // the code are divided off into different modules, or functions, that
  // perform specific calculations on that data and spit out some result.
  // Another way is object oriented programming, which I can show you an
  // example of at the end of the class. This is outside the scope of
  // this class, but it's worth knowing about.
  drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  

  // We want to get the direciton of the users' body as well. We've created
  // another function to do this. This keeps our code clean and readable.
  getBodyDirection(userId,bodyCenter,bodyDir);
  
  // We know that bodyDir is a vector, meaning that it is a set of three numbers
  // that represent some force or direction. If we want to do math
 // on a vector, we want to be using vector operations.
 // Recommend giving Dan Shiffman's tutorials a look for more: 
  //http://www.shiffman.net/teaching/nature/vectors/
  // Hugely important, kinda tough to wrap your head around unles you
  // really play with it for a bit.
  bodyDir.mult(200);  // 200mm length
  bodyDir.add(bodyCenter);
  
  // Draw a line from the center of the body and in the direction
  // that it is going.
  stroke(255,200,200);
  line(bodyCenter.x,bodyCenter.y,bodyCenter.z,
       bodyDir.x ,bodyDir.y,bodyDir.z);

  strokeWeight(1);
 
}

// Alright, onto the draw limbs function. We used this extensively in 
// the drawSkeleton function to pull together the different parts of
// the body that we're tracking.
// The drawLimb function takes three arguments: the userID, and the two
// "joints" that connect the limb we're creating.
void drawLimb(int userId,int jointType1,int jointType2)
{
  // We declare the two join vectors. These variables, jointPos1 and
  // jointPos2 only exist within this function. After this functino is
  // run, they disappear. This is an issue called variable scope, which
  // I can describe in more detail. There is also a demo here:
  // http://processing.org/learning/basics/variablescope.html
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;
  
  // Finally, some openNI methods! Here, we're calling the method
  // getJointPositionSkeleton. There's something a litte odd going on here.
  // the method getJointPositionSkeleton returns a boolean value, and is
  // a flag for retrieving that information in hte openNI system. This
  // seems to just write it twice, saying "does this exist? If yes, then draw"
  confidence = context.getJointPositionSkeleton(userId,jointType1,jointPos1);
  confidence = context.getJointPositionSkeleton(userId,jointType2,jointPos2);

  // And here we draw it with transparency.
  stroke(255,0,0,confidence * 200 + 55);
  line(jointPos1.x,jointPos1.y,jointPos1.z,
       jointPos2.x,jointPos2.y,jointPos2.z);
       
  // Next, we draw the orientation of the join, which we see below as
  // a separate function.
  drawJointOrientation(userId,jointType1,jointPos1,50);
}

// We're drawing the orientation of the joints here: their direction
// and vector of movement. The arguments we need are the user IDs,
// the type of join, the position, and the length of the joint.
void drawJointOrientation(int userId,int jointType,PVector pos,float length)
{
  // We're getting into scary territory here.
  // We don't touch on the PMatrix much here, but when we instantiate this
  // object, we're making a set of default values, essentially.
  // Read more about PMatrix3D here:
  // http://forum.processing.org/topic/understanding-pmatrix3d
  // and the actual implementation of pmatrix3d is here:
  // http://code.google.com/p/processing/source/browse/trunk/processing/core/src/processing/core/PMatrix3D.java
  PMatrix3D  orientation = new PMatrix3D();
  
  // Again with the confidence test.
  float confidence = context.getJointOrientationSkeleton(userId,jointType,orientation);
  if(confidence < 0.001f) 
    // nothing to draw, orientation data is useless.
    // This is a short form in Java that returns null
    // if there's nothing to draw. It's like saying "If there isn't
    // anything, stop otherwise keep going!"
    return;
    
  // Pushing and popping matricies is fundamental to how we reposition objects
  // in space. Think of it as "building something in a known location, and then
  // putting it where you want it to be."   
  pushMatrix();
    // We move the default area to the below position
    translate(pos.x,pos.y,pos.z);
    
    // We apply the location matrix we described in the oriention variable.
    // For more on this method, see: http://processing.org/reference/applyMatrix_.html
    applyMatrix(orientation);
    
    // Finally, we draw the actual limb. Notice how all the positions are
    // at defined areas, not using variable coordinates? That's because we
    // positioned this "workbench" in space, instead of positioning the
    // object in space. This is what's awesome about pushMatrx/popMatrix
    // coordsys lines are 100mm long
    // x - r
    stroke(255,0,0,confidence * 200 + 55);
    line(0,0,0,
         length,0,0);
    // y - g
    stroke(0,255,0,confidence * 200 + 55);
    line(0,0,0,
         0,length,0);
    // z - b    
    stroke(0,0,255,confidence * 200 + 55);
    line(0,0,0,
         0,0,length);
  popMatrix();
}





// -----------------------------------------------------------------
// SimpleOpenNI user events
// Next, we need to deal with events. Events are things that occur during 
// the program, and we can over-ride or customize how they work by defining
// them here. This works in the same way void keyPressed() does.


void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");
  
  if(autoCalib)
    context.requestCalibrationSkeleton(userId,true);
  else    
    context.startPoseDetection("Psi",userId);
}

// When a user's tracking is lost
void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

// When a user exits cleanly
void onExitUser(int userId)
{
  println("onExitUser - userId: " + userId);
}

// When a user re-enters the scene cleanly
void onReEnterUser(int userId)
{
  println("onReEnterUser - userId: " + userId);
}

// Starts calibration
void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

// Ends calibration
void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
  
  if (successfull) 
  { 
    println("  User calibrated !!!");
    context.startTrackingSkeleton(userId); 
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    context.startPoseDetection("Psi",userId);
  }
}

// When a start pose is detected (holding both hands up)
void onStartPose(String pose,int userId)
{
  println("onStartdPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");
  
  context.stopPoseDetection(userId); 
  context.requestCalibrationSkeleton(userId, true);
 
}

// Didn't know there was an end pose. Weird, eh?
void onEndPose(String pose,int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}

// -----------------------------------------------------------------
// Keyboard events
// These are just 
void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
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
        zoomF += 0.01f;
      else
        rotX += 0.1f;
      break;
    case DOWN:
      if(keyEvent.isShiftDown())
      {
        zoomF -= 0.01f;
        if(zoomF < 0.01)
          zoomF = 0.01;
      }
      else
        rotX -= 0.1f;
      break;
  }
}

void getBodyDirection(int userId,PVector centerPoint,PVector dir)
{
  PVector jointL = new PVector();
  PVector jointH = new PVector();
  PVector jointR = new PVector();
  float  confidence;
  
  // draw the joint position
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,jointL);
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,jointH);
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,jointR);
  
  // take the neck as the center point
  confidence = context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,centerPoint);
  
  /*  // manually calc the centerPoint
  PVector shoulderDist = PVector.sub(jointL,jointR);
  centerPoint.set(PVector.mult(shoulderDist,.5));
  centerPoint.add(jointR);
  */
  
  PVector up = new PVector();
  PVector left = new PVector();
  
  up.set(PVector.sub(jointH,centerPoint));
  left.set(PVector.sub(jointR,centerPoint));
  
  dir.set(up.cross(left));
  dir.normalize();
}
