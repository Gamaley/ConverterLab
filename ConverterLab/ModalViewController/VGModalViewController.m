//
//  VGModalViewController.m
//  ConverterLab
//
//  Created by Vladyslav on 19.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "VGModalViewController.h"
#import "VGServerManager.h"
#import "VGLoginViewController.h"
#import "VGServerManager.h"


@interface VGModalViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *usdCurrency;
@property (weak, nonatomic) IBOutlet UILabel *eurCurrency;
@property (weak, nonatomic) IBOutlet UILabel *rubCurrency;
@property (weak ,nonatomic) IBOutlet UIView *infoView;


@end


@implementation VGModalViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
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

#pragma mark - Actions

- (IBAction)dismissViewControllerAction:(UIButton *)sender {
    [self shareOptionsAction];
}

#pragma mark - Private

- (void) shareOptionsAction {
    
    UIAlertController* chooseShare = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* emailAction = [UIAlertAction actionWithTitle:@"Отправить e-mail" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *emailTitle = [NSString stringWithFormat:@"Информация курса валют по банку: %@",self.titleString];
        NSString *messageBody = [NSString stringWithFormat:@"Банк: %@\nUSD - %@ \nEUR - %@ \nПерейти на страничку описания: %@",self.titleString, self.eurCurrency.text, self.eurCurrency.text, self.linkString];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [self presentViewController:mc animated:YES completion:NULL];
        
        
    }];
    
    UIAlertAction* vkontakteAction = [UIAlertAction actionWithTitle:@"Поделиться Вконтакте" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *message = [NSString stringWithFormat:@"Информация курса валют по банку: %@\nБанк: %@\nUSD - %@ \nEUR - %@ \nПерейти на страничку описания: %@",self.titleString,self.titleString, self.eurCurrency.text, self.eurCurrency.text, self.linkString];
        
        [[VGServerManager sharedManager]postText:message onMyWallVKOnSuccess:^(id result) {
            UIAlertController* postSend = [UIAlertController alertControllerWithTitle:@"Сообщение отправлено!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* emailAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [postSend addAction:emailAction];
            [self presentViewController:postSend animated:YES completion:^{}];
        } onFailure:^(NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
        }];
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {return;}];
    
    [chooseShare addAction:emailAction];
    [chooseShare addAction:vkontakteAction];
    [chooseShare addAction:cancel];
    
    [self presentViewController:chooseShare animated:YES completion:^{
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.infoView];
    BOOL isTouched = [self.infoView pointInside:point withEvent:event];
    
    if (!isTouched) {
    [self dismissViewControllerAnimated:YES completion:nil];
    }

    
    
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
