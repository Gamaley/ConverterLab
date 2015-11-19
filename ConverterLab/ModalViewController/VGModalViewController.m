//
//  VGModalViewController.m
//  ConverterLab
//
//  Created by Vladyslav on 19.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGModalViewController.h"
#import <MessageUI/MessageUI.h>

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

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
// 
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.titleString;
    self.regionLabel.text = self.regionString;
    self.cityLabel.text = self.cityString;
    self.usdCurrency.text = self.usdCurrencyString;
    self.eurCurrency.text = self.eurCurrencyString;
    self.rubCurrency.text = self.rubCurrencyString;
    if (!self.rubCurrency.text) {
        NSLog(@"Скрыть RUB Label");
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissViewControllerAction:(UIButton *)sender {
    
    //NSLog(@"ds");
    
    NSString *emailTitle = [NSString stringWithFormat:@"Информация курса валют по банку: %@",self.titleString];
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Банк: %@\nUSD - %@ \nEUR - %@ \nПерейти на страничку описания: %@",self.titleString, self.eurCurrency.text, self.eurCurrency.text, self.linkString];
    // To address
    //NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    //[mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
