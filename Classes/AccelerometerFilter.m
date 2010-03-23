// 
//   AccelerometerFilter.m
//   AcceleratedBell
//   
//   Created by kazuya kawaguchi on 2010-03-14.
//   Copyright 2010 kazuya kawaguchi. All rights reserved.
// 


#import "AccelerometerFilter.h"


@implementation AccelerometerFilter


@synthesize x, y, z;


- (id)initWithSamplingRate:(double)samplingRate 
      cutOffFrequency:(double)frequency {
    
    if((self = [super init])) {
        double dt = 1.0 / samplingRate;
        double RC = 1.0 / frequency;
        filteringFactor = dt / (dt + RC);
        DEBUG(@"filteringFactor = %f", filteringFactor);
    }
    
    return self;
}


- (void)doFiltering:(double)accelX y:(double)accelY z:(double)accelZ {
    
}


@end
