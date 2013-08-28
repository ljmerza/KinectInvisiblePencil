import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue;
int closestX;
int closestY;
float lastX;
float lastY;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.setMirror(true); 
;
}

void draw()
{
  closestValue = 550;
  kinect.update();
  int[] depthValues = kinect.depthMap();
  for(int y = 0; y < 480; y++)
  {
    for(int x = 0; x < 640; x++)
    {
      int i = x + y * 640;
      int currentDepthValue = depthValues[i];
      if(currentDepthValue > 0 && currentDepthValue < closestValue)
      {
        closestValue = currentDepthValue;
         closestX = x;
        closestY = y;
      }
    }
  }
  // "linear interpolation", i.e.
  // smooth transition between last point
  // and new closest point
  float interpolatedX = lerp(lastX, closestX, 0.3f);
  float interpolatedY = lerp(lastY, closestY, 0.3f);
  stroke(255,0,0);
  // make a thicker line, which looks nicer
  strokeWeight(3);
  line(lastX, lastY, interpolatedX, interpolatedY);
  
  if(abs(lastX - interpolatedX) < 20 & abs(lastY - interpolatedY) < 20)
  {
    lastX = interpolatedX;
    lastY = interpolatedY;
  }
  
}

void mousePressed()
{
  // save image to a file
  // then clear it on the screen
  save("drawing.png");
  background(0);
}
