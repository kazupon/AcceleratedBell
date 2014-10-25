//
//  AcceleratedBellAppDelegate.m
//  AcceleratedBell
//
//  Created by kazuya kawaguchi on 3/14/10.
//  Copyright kazuya kawaguchi 2010. All rights reserved.
//

#import "AcceleratedBellAppDelegate.h"
#import "AcceleratedBellViewController.h"

@implementation AcceleratedBellAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after app launch
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
