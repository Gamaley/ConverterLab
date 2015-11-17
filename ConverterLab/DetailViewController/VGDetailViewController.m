//
//  VGDetailViewController.m
//  ConverterLab
//
//  Created by Vladyslav on 17.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGDetailViewController.h"

@interface VGDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *detailInfoView;
@property (weak, nonatomic) IBOutlet UIView *nameCurrencyView;
@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;

@end

@implementation VGDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingsView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

-(void) settingsView {
    
    self.detailInfoView.layer.masksToBounds = NO;
    self.detailInfoView.layer.shadowOffset = CGSizeMake(-2, 4);
    self.detailInfoView.layer.shadowRadius = 3;
    self.detailInfoView.layer.shadowOpacity = 0.5;
    
    self.nameCurrencyView.layer.masksToBounds = NO;
    self.nameCurrencyView.layer.shadowOffset = CGSizeMake(-2, 4);
    self.nameCurrencyView.layer.shadowRadius = 3;
    self.nameCurrencyView.layer.shadowOpacity = 0.5;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
