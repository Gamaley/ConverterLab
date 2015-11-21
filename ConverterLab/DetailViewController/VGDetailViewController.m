//
//  VGDetailViewController.m
//  ConverterLab
//
//  Created by Vladyslav on 17.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGDetailViewController.h"
#import "VGDataManager.h"
#import "VGDetailTableViewCell.h"
#import "Currency.h"
#import "VGModalViewController.h"
#import "VGMapAnnotation.h"
#import "VGMapViewController.h"
#import "VGServerManager.h"



@interface VGDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailInfoView;
@property (weak, nonatomic) IBOutlet UIView *nameCurrencyView;
@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *hamburgerMenuView;
@property (weak, nonatomic) IBOutlet UIButton *hamburgerButton;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;


@property (strong, nonatomic) VGModalViewController *modal;
@property (assign ,nonatomic) BOOL firstTimeAppear;


@end

@implementation VGDetailViewController


#pragma mark - Actions

- (IBAction)mapAction:(UIButton *)sender {
    VGMapViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VGMapViewController"];
    vc.mapAnnotation = self.mapAnnotation;
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)linkAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkString]];
}

- (IBAction)phoheAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneString]]];
}

- (IBAction)optionsActionHamburger:(UIButton *)sender {
    if (self.hamburgerMenuView.isHidden) {
        [self.hamburgerButton setSelected:YES];
        [self.hamburgerMenuView setHidden: NO];
    } else {
        [self.hamburgerMenuView setHidden: YES];
        [self.hamburgerButton setSelected:NO];
    }
    
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = self.titleString;
    self.regionLabel.text = self.regionString;
    self.cityLabel.text = self.cityString;
    self.addressLabel.text = self.addressString;
    self.phoneLabel.text = self.phoneString;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingsView];
    
    if (![VGServerManager sharedManager].tokenExist) {
        [[VGServerManager sharedManager] authorizeUserWithController:self andCompletitionBlock:^(VGAccessToken *userToken) {
            NSLog(@"Ура! Токен получен!");
            
        }];
    }
    
}

#pragma mark - Private

-(void) settingsView {
    
    self.currencyTableView.layer.masksToBounds = NO;
    self.currencyTableView.layer.shadowOffset = CGSizeMake(-2, 4);
    self.currencyTableView.layer.shadowRadius = 3;
    self.currencyTableView.layer.shadowOpacity = 0.5;
    
    self.detailInfoView.layer.masksToBounds = NO;
    self.detailInfoView.layer.shadowOffset = CGSizeMake(-2, 4);
    self.detailInfoView.layer.shadowRadius = 3;
    self.detailInfoView.layer.shadowOpacity = 0.5;
    
    self.nameCurrencyView.layer.masksToBounds = NO;
    self.nameCurrencyView.layer.shadowOffset = CGSizeMake(-2, 4);
    self.nameCurrencyView.layer.shadowRadius = 3;
    self.nameCurrencyView.layer.shadowOpacity = 0.5;
    
    self.hamburgerButton.layer.shadowOffset = CGSizeMake(1, 0);
    self.hamburgerButton.layer.cornerRadius = self.hamburgerButton.frame.size.width/2;
    self.hamburgerButton.layer.shadowRadius = 5;
    self.hamburgerButton.layer.shadowOpacity = .25;
    
    self.mapButton.layer.shadowOffset = CGSizeMake(1, 0);
    self.mapButton.layer.cornerRadius = self.hamburgerButton.frame.size.width/2;
    self.mapButton.layer.shadowRadius = 5;
    self.mapButton.layer.shadowOpacity = .25;
    
    self.linkButton.layer.shadowOffset = CGSizeMake(1, 0);
    self.linkButton.layer.cornerRadius = self.hamburgerButton.frame.size.width/2;
    self.linkButton.layer.shadowRadius = 5;
    self.linkButton.layer.shadowOpacity = .25;

    self.phoneButton.layer.shadowOffset = CGSizeMake(1, 0);
    self.phoneButton.layer.cornerRadius = self.hamburgerButton.frame.size.width/2;
    self.phoneButton.layer.shadowRadius = 5;
    self.phoneButton.layer.shadowOpacity = .25;

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}


-(void) shareAction: (UIBarButtonItem *) sender {

    // Пока реализовано через сторибоард. В ближайшее время исправлю, и доделаю через код.
    self.modal = [self.storyboard instantiateViewControllerWithIdentifier:@"VGModalViewController"];
    [self.modal setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    self.modal.titleString = self.titleString;
    self.modal.regionString = self.regionString;
    self.modal.cityString = self.cityString;
    self.modal.linkString = self.linkString;
    
    for (Currency* i in self.currencyArray) {
        if ([i.engName isEqualToString:@"USD"]) {
            self.modal.usdCurrencyString = [NSString stringWithFormat:@"%1.2f/%1.2f",[i.bid doubleValue],[i.ask doubleValue]];
        }
        if ([i.engName isEqualToString:@"EUR"]) {
            self.modal.eurCurrencyString = [NSString stringWithFormat:@"%1.2f/%1.2f",[i.bid doubleValue],[i.ask doubleValue]];
        }
        if ([i.engName isEqualToString:@"RUB"]) {
            self.modal.rubCurrencyString = [NSString stringWithFormat:@"%1.2f/%1.2f",[i.bid doubleValue],[i.ask doubleValue]];
        }
    }

    [self presentViewController:self.modal animated:YES completion:^{}];

}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currencyArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* Identifier = @"DetailCell";
    VGDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[VGDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(VGDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Currency *aCurrency = [self.currencyArray objectAtIndex:indexPath.row];
    cell.nameCurrencyString = aCurrency.name;
    cell.askCurrencyString = [aCurrency.ask stringValue];
    cell.bidCurrencyString = [aCurrency.bid stringValue];
    [cell awakeFromNib];
    
}




@end
