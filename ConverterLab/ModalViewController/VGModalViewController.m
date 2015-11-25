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
    // Не убирал реализацию через сторибоард. Вьюху там поставил скрытой. 
    //Просто добавил появление экрана диалога в этом методе ниже.
    [self customView];
    
}

#pragma mark - Actions

- (IBAction)dismissViewControllerAction:(UIButton *)sender {
    [self shareOptionsAction];
}

#pragma mark - Private

-(void) customView {
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(18, 100, 288, 354)];
    shareView.autoresizesSubviews = NO;
    shareView.backgroundColor = [UIColor whiteColor];
    UIColor *titleColour = [UIColor colorWithRed:207/255.0 green:36/255.0 blue:122/255.0 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 282, 44)];
    UILabel *regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 66, 282, 21)];
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 85, 282, 21)];
    UILabel *usdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 138, 71, 38)];
    UILabel *eurLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 184, 71, 38)];
    UILabel *rubLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, 71, 38)];
    UILabel *usdAskBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(134, 144, 135, 25)];
    UILabel *eurAskBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(134, 190, 135, 25)];
    UILabel *rubAskBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(134, 236, 135, 25)];
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 317, 288, 37)];
    
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    titleLabel.textColor = titleColour;
    usdLabel.textColor = titleLabel.textColor;
    eurLabel.textColor = titleLabel.textColor;
    rubLabel.textColor = titleLabel.textColor;
    
    titleLabel.font = [UIFont boldSystemFontOfSize:22.f];
    usdLabel.font = [UIFont boldSystemFontOfSize:21.f];
    eurLabel.font = usdLabel.font;
    rubLabel.font = usdLabel.font;
    regionLabel.font = [UIFont systemFontOfSize:15.f];
    cityLabel.font = regionLabel.font;
    usdAskBidLabel.font = [UIFont systemFontOfSize:17.f];
    eurAskBidLabel.font = usdAskBidLabel.font;
    rubAskBidLabel.font = usdAskBidLabel.font;
    
    [shareButton setTitleColor:titleLabel.textColor forState:UIControlStateNormal];
    shareButton.backgroundColor = [UIColor colorWithRed:165/255.0 green:184/255.0 blue:196/255.0 alpha:1.f];
    [shareButton setTitle:@"SHARE" forState:UIControlStateNormal];
    
    usdLabel.text = @"USD";
    eurLabel.text = @"EUR";
    rubLabel.text = @"RUB";
    
    usdAskBidLabel.text = self.usdCurrencyString;
    eurAskBidLabel.text = self.eurCurrencyString;
    rubAskBidLabel.text = self.rubCurrencyString;
    
    titleLabel.text = self.titleString;
    cityLabel.text = self.cityString;
    regionLabel.text = self.regionString;
    
    
    
    [shareView addSubview:titleLabel];
    [shareView addSubview:regionLabel];
    [shareView addSubview:cityLabel];
    [shareView addSubview:usdLabel];
    [shareView addSubview:eurLabel];
    [shareView addSubview:rubLabel];
    [shareView addSubview:usdAskBidLabel];
    [shareView addSubview:eurAskBidLabel];
    [shareView addSubview:rubAskBidLabel];
    [shareView addSubview:shareButton];
    
    
    
    shareView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:shareView];
}

-(void) share {
    [self shareOptionsAction];
}

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
