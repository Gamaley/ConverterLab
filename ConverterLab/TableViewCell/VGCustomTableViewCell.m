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

@end


@implementation VGCustomTableViewCell

- (void)awakeFromNib {
    
    // Initialization code
    //
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
