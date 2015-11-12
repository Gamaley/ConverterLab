//
//  ViewController.m
//  ConverterLab
//
//  Created by Vladyslav on 12.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGTableViewController.h"
#import "VGServerManager.h"

@interface VGTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation VGTableViewController

-(void) getBanksFromServer {
    
    [[VGServerManager sharedManager] getBankOnSuccess:^(NSArray *banks) {
        
    } onFailure:^(NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* docunentDirectory = [pathArray objectAtIndex:0];
    
    [self getBanksFromServer];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //[UITabBar appearance].tintColor = [UIColor redColor];//[UIColor colorWithRed:255 green:54 blue:212 alpha:1];
      // self.tableView.co // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* Identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    
   // cell.delegate = self;
    //[self configureCell:cell atIndexPath:indexPath];
    return  cell;
}



#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if (item.tag == 1) {
        NSLog(@"11");
    } else if (item.tag == 2) {
        NSLog(@"22");
    } else if (item.tag == 3) {
        NSLog(@"33");
    } else if (item.tag == 4) {
        NSLog(@"44");
    }

}

@end
