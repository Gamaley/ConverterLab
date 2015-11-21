//
//  VGDetailTableViewCell.m
//  ConverterLab
//
//  Created by Vladyslav on 17.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGDetailTableViewCell.h"

@interface VGDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *nameCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *askCurrencyLabel;


@end

@implementation VGDetailTableViewCell

- (void)awakeFromNib {
    
    self.nameCurrencyLabel.text = self.nameCurrencyString;
    self.bidCurrencyLabel.text = self.bidCurrencyString;
    self.askCurrencyLabel.text = self.askCurrencyString;
  
}

@end
