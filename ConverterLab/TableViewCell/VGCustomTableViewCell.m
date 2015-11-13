//
//  VGCustomTableViewCell.m
//  ConverterLab
//
//  Created by Vladyslav on 12.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGCustomTableViewCell.h"

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

@end


@implementation VGCustomTableViewCell

- (void)awakeFromNib {
    
    self.titleLabel.text = self.titleString;
    self.regionLabel.text = self.regionString;
    self.cityLabel.text = self.cityString;
    self.addressLabel.text = self.addressString;
    self.phoneLabel.text = [NSString stringWithFormat:@"тел.: +38%@", self.phoneString];
    
    // Initialization code
    //
}

-(IBAction)linkButtonAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkString]];
}

-(IBAction)mapButtonAction:(UIButton *)sender {
    
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
