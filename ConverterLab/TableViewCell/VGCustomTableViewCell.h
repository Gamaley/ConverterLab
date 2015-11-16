//
//  VGCustomTableViewCell.h
//  ConverterLab
//
//  Created by Vladyslav on 12.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VGCustomTableViewCellDelegate;

@interface VGCustomTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *regionString;
@property (strong, nonatomic) NSString *cityString;
@property (strong, nonatomic) NSString *addressString;
@property (strong, nonatomic) NSString *phoneString;
@property (strong, nonatomic) NSString *linkString;

@property (weak, nonatomic) id <VGCustomTableViewCellDelegate> delegate;

@end


@protocol VGCustomTableViewCellDelegate <NSObject>

-(void) cellOpenMapAnnotation: (VGCustomTableViewCell*) cell;

@end