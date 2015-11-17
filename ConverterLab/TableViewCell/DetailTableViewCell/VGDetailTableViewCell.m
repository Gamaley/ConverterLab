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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
