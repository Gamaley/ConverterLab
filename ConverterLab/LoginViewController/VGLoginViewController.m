//
//  VGLoginViewController.m
//  ConverterLab
//
//  Created by Vladyslav on 20.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGLoginViewController.h"
#import "VGAccessToken.h"
#import "VGServerManager.h"
#import "AFNetworking.h"

@interface VGLoginViewController () <UIWebViewDelegate>
@property (copy, nonatomic) VGCompletitionBlock completitionBlock;
@end


@implementation VGLoginViewController

-(id) initWithCompletitionBlock:(VGCompletitionBlock)completitionBlock {
    
    self = [super init];
    
    if (self) {
        self.completitionBlock = completitionBlock;
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor lightGrayColor];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:webView];
    webView.delegate = self;
    
    NSString *urlString = @"https://oauth.vk.com/authorize?client_id=5155452&scope=wall&redirect_uri=http://api.vk.com/blank.html&display=mobile&v=5.40&response_type=token&revoke=1";
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.completitionBlock) {
        self.completitionBlock(nil);
    }
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] host] isEqualToString:@"api.vk.com"]) {
        
        VGAccessToken *token = [[VGAccessToken alloc] init];
        
        NSString *query = [[request URL] description];
        NSArray * arr = [query componentsSeparatedByString:@"#"];
        
        if ([arr count] > 1) {
            query = [arr lastObject];
        }
        
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString *pair in pairs) {
            
            NSArray *values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                NSString *key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    token.token = [values lastObject];
                } else if ([key isEqualToString:@"expires_in"]) {
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                } else if ([key isEqualToString:@"user_id"]) {
                    token.userID = [values lastObject];
                }
            }
            
        }
        
         webView.delegate = nil;
        
        if (self.completitionBlock) {
            self.completitionBlock(token);
                }

       [self dismissViewControllerAnimated:YES completion:nil];

        return NO;
    }
    
    NSLog(@"%@",[request URL]);

    return YES;
}


@end