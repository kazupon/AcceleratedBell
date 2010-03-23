// 
//   AcceleratedBellViewController.m
//   AcceleratedBell
//   
//   Created by kazuya kawaguchi on 2010-03-14.
//   Copyright 2010 kazuya kawaguchi. All rights reserved.
// 


#import "AcceleratedBellViewController.h"


#define kUpdateFrequency    60.0
#define DIST(X, Y, Z)   sqrtf(((X)*(X)) + ((Y)*(Y)) + ((Z)*(Z)));


@implementation AcceleratedBellViewController


- (NSURL *)fromURL:(NSString *)fileName type:(NSString *)typeName {
    
    NSString *fromPath = [[NSBundle mainBundle] pathForResource:fileName 
                                                ofType:typeName];
    return [NSURL fileURLWithPath:fromPath];
    
}


- (void)accelerometer:(UIAccelerometer *)accelerometer 
        didAccelerate:(UIAcceleration *)acceleration {
    
    static BOOL detectingShake;
    
    if(detectingShake) {
        DEBUG(@"Already Detect Shake.");
        return;
    }
    
    
    detectingShake = YES;
    double x = acceleration.x - lastX;
    double y = acceleration.y - lastY;
    double z = acceleration.z - lastZ;
    
    double dist = DIST(x, y, z);
    if(fabs(dist) > sensitivityValue) {
        DEBUG(@"Detect Shake : dist = %f", dist);
        [player play];
        labelCount.text = [NSString stringWithFormat:@"%d Ringing", 
                                                     player.playCount, nil];
    }
    
    detectingShake = NO;
    
    
    lastX = acceleration.x;
    lastY = acceleration.y;
    lastZ = acceleration.z;
}



- (IBAction)changedSensitivityValue:(id)sender {
    UISlider *slider = sender;
    sensitivityValue = slider.value;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sensitivityValue = sliderSensitivity.value;
    
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 1.0 / kUpdateFrequency;
    accelerometer.delegate = self;
    
    NSURL *url = [self fromURL:@"bell" type:@"mp3"];
    player = [[BellPlayer alloc] initWithContentsOfURL:url];
    [player start];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


- (void)dealloc {
    
    [player release];
    
    [super dealloc];
}


@end
