// 
//   AccelerometerLowPassFilter.h
//   AcceleratedBell
//   
//   Created by kazuya kawaguchi on 2010-03-14.
//   Copyright 2010 kazuya kawaguchi. All rights reserved.
// 


#import <Foundation/Foundation.h>
#import "AccelerometerFilter.h"


@interface AccelerometerLowPassFilter : AccelerometerFilter {

}

- (void)doFiltering:(double)accelX y:(double)accelY z:(double)accelZ;

@end
