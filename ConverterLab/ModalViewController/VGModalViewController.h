//
//  VGModalViewController.h
//  ConverterLab
//
//  Created by Vladyslav on 19.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VGModalViewController : UIViewController

@property (weak, nonatomic)  NSString *titleString;
@property (weak, nonatomic)  NSString *regionString;
@property (weak, nonatomic)  NSString *cityString;
@property (weak, nonatomic)  NSString *usdCurrencyString;
@property (weak, nonatomic)  NSString *eurCurrencyString;
@property (weak, nonatomic)  NSString *rubCurrencyString;
@property (strong, nonatomic) NSString *linkString;

@end
