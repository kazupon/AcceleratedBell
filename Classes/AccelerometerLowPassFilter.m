// 
//   AccelerometerLowPassFilter.m
//   AcceleratedBell
//   
//   Created by kazuya kawaguchi on 2010-03-14.
//   Copyright 2010 kazuya kawaguchi. All rights reserved.
// 


#import "AccelerometerLowPassFilter.h"


@implementation AccelerometerLowPassFilter


- (void)doFiltering:(double)accelX y:(double)accelY z:(double)accelZ {
    
    DEBUG(@"accelX = %f, accelY = %f, accelZ = %f", accelX, accelY, accelZ);
    
    double alpha = filteringFactor;
    x = accelX * alpha + x * (1.0 - alpha);
    y = accelY * alpha + y * (1.0 - alpha);
    z = accelZ * alpha + z * (1.0 - alpha);
    DEBUG(@"x = %f, y = %f, z = %f", x, y, z);
    
}


@end
