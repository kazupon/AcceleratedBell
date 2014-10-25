//
//   AccelerometerFilter.h
//   AcceleratedBell
//
//   Created by kazuya kawaguchi on 2010-03-14.
//   Copyright 2010 kazuya kawaguchi. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface AccelerometerFilter : NSObject {
    double filteringFactor;
    double x;
    double y;
    double z;
}

- (id)initWithSamplingRate:(double)samplingRate
      cutOffFrequency:(double)frequency;
- (void)doFiltering:(double)accelX y:(double)accelY z:(double)accelZ;

@property double x;
@property double y;
@property double z;


@end
