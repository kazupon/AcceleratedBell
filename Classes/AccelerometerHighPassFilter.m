//
//   AccelerometerHighPassFilter.m
//   AcceleratedBell
//
//   Created by kazuya kawaguchi on 2010-03-14.
//   Copyright 2010 kazuya kawaguchi. All rights reserved.
//


#import "AccelerometerHighPassFilter.h"


@implementation AccelerometerHighPassFilter


- (void)doFiltering:(double)accelX y:(double)accelY z:(double)accelZ {

    DEBUG(@"accelX = %f, accelY = %f, accelZ = %f", accelX, accelY, accelZ);

    double alpha = filteringFactor;
    x = alpha * (x + accelX - lastX);
    y = alpha * (y + accelY - lastY);
    z = alpha * (z + accelZ - lastZ);
    DEBUG(@"x = %f, y = %f, z = %f", x, y, z);

    lastX = accelX;
    lastY = accelY;
    lastZ = accelZ;

}


@end
