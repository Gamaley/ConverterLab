//
//  VGModalViewController.m
//  ConverterLab
//
//  Created by Vladyslav on 19.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGModalViewController.h"

@interface VGModalViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *usdCurrency;
@property (weak, nonatomic) IBOutlet UILabel *eurCurrency;
@property (weak, nonatomic) IBOutlet UILabel *rubCurrency;

@end

@implementation VGModalViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = self.titleString;
    self.regionLabel.text = self.regionString;
    self.cityLabel.text = self.cityString;
    self.usdCurrency.text = self.usdCurrencyString;
    self.eurCurrency.text = self.eurCurrencyString;
    self.rubCurrency.text = self.rubCurrencyString;
    if (!self.rubCurrency.text) {
        NSLog(@"Скрыть RUB Label");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissViewControllerAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
