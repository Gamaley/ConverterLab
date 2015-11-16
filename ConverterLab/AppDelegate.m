//
//  AppDelegate.m
//  ConverterLab
//
//  Created by Vladyslav on 12.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "AppDelegate.h"
#import "VGDataManager.h"
#import "VGServerManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[VGDataManager sharedManager] saveContext];
}


@end
