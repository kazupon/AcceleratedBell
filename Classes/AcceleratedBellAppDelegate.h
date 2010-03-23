//
//  AcceleratedBellAppDelegate.h
//  AcceleratedBell
//
//  Created by kazuya kawaguchi on 3/14/10.
//  Copyright kazuya kawaguchi 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AcceleratedBellViewController;

@interface AcceleratedBellAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AcceleratedBellViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AcceleratedBellViewController *viewController;

@end

