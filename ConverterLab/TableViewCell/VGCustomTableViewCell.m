//
//  VGCustomTableViewCell.m
//  ConverterLab
//
//  Created by Vladyslav on 12.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGCustomTableViewCell.h"

@interface VGCustomTableViewCell ()

@property (weak, nonatomic) IBOutlet UITabBarItem *linkTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *mapTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *callTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *moreTabBarItem;
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
    self.phoneLabel.text = self.phoneString;
    
    // Initialization code
    //
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
