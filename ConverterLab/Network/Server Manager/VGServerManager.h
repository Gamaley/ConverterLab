//
//  VGServerManager.h
//  ConverterLab
//
//  Created by Vladyslav on 12.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VGServerManager : NSObject

+(VGServerManager*) sharedManager;

-(void) getBankOnSuccess:(void(^)(NSArray* banks)) success onFailure:(void(^)(NSError* error)) failure;


@end
