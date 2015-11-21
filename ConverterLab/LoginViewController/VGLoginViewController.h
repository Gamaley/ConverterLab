//
//  VGLoginViewController.h
//  ConverterLab
//
//  Created by Vladyslav on 20.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VGAccessToken;

typedef void(^VGCompletitionBlock)(VGAccessToken *token);

@interface VGLoginViewController : UIViewController

-(id) initWithCompletitionBlock: (VGCompletitionBlock) completitionBlock;

@end
