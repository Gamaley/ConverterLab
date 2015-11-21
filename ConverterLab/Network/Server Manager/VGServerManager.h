//
//  VGServerManager.h
//  ConverterLab
//
//  Created by Vladyslav on 12.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VGAccessToken, UIViewController;


@interface VGServerManager : NSObject


@property (assign, nonatomic) BOOL tokenExist;


+(VGServerManager*) sharedManager;
-(void) getBankOnSuccess:(void(^)(id banks)) success onFailure:(void(^)(NSError* error)) failure;
-(void) authorizeUserWithController: (UIViewController *) controller andCompletitionBlock: (void (^) (VGAccessToken *userToken)) completition;
-(void) postText:(NSString *) text onMyWallVKOnSuccess:(void(^)(id result)) success onFailure:(void(^)(NSError* error)) failure;

@end
