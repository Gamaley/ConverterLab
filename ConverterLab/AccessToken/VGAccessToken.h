//
//  VGAccessToken.h
//  ConverterLab
//
//  Created by Vladyslav on 20.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VGAccessToken : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong ,nonatomic) NSDate *expirationDate;
@property (strong, nonatomic) NSString *userID;

@end
