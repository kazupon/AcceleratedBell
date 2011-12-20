//
//   AcceleratedBellViewController.h
//   AcceleratedBell
//
//   Created by kazuya kawaguchi on 2010-03-14.
//   Copyright 2010 kazuya kawaguchi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BellPlayer.h"

@interface AcceleratedBellViewController :
                                UIViewController <UIAccelerometerDelegate> {
    BellPlayer *player;
    double lastX;
    double lastY;
    double lastZ;
    double sensitivityValue;

    IBOutlet UILabel *labelCount;
    IBOutlet UISlider *sliderSensitivity;
}


- (IBAction)changedSensitivityValue:(id)sender;


@end

