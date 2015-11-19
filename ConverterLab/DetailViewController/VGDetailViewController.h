//
//  VGDetailViewController.h
//  ConverterLab
//
//  Created by Vladyslav on 17.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VGMapAnnotation;

@interface VGDetailViewController : UIViewController

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *regionString;
@property (strong, nonatomic) NSString *cityString;
@property (strong, nonatomic) NSString *addressString;
@property (strong, nonatomic) NSString *phoneString;
@property (strong, nonatomic) NSString *linkString;
@property (strong, nonatomic) NSArray *currencyArray;
@property (strong, nonatomic) VGMapAnnotation *mapAnnotation;


@end
