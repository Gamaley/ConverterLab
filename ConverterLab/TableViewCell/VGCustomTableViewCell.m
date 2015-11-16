//
//  VGCustomTableViewCell.m
//  ConverterLab
//
//  Created by Vladyslav on 12.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGCustomTableViewCell.h"
#import "VGMapViewController.h"
#import "VGTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface VGCustomTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end


@implementation VGCustomTableViewCell

- (void)awakeFromNib {
    
    self.shadowView.layer.masksToBounds = NO;
    self.shadowView.layer.shadowOffset = CGSizeMake(-2, 4);
    self.shadowView.layer.shadowRadius = 3;
    self.shadowView.layer.shadowOpacity = 0.5;
    
    self.titleLabel.text = self.titleString;
    self.regionLabel.text = self.regionString;
    self.cityLabel.text = self.cityString;
    self.addressLabel.text = self.addressString;
    self.phoneLabel.text = [NSString stringWithFormat:@"тел.: +38%@", self.phoneString];

}

-(IBAction)linkButtonAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkString]];
}

-(IBAction)mapButtonAction:(UIButton *)sender {
    [self.delegate cellOpenMapAnnotation:self];
}

-(IBAction)callButtonAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneString]]];
}

-(IBAction)moreButtonAction:(UIButton *)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
