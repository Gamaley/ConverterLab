//
//  VGMapViewController.h
//  ConverterLab
//
//  Created by Vladyslav on 13.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VGMapAnnotation;


@interface VGMapViewController : UIViewController

@property (strong, nonatomic) VGMapAnnotation *mapAnnotation;

@end
