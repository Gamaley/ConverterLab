//
//  ViewController.m
//  ConverterLab
//
//  Created by Vladyslav on 12.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGTableViewController.h"
#import "VGServerManager.h"
#import "VGCustomTableViewCell.h"
#import "City.h"
#import "Region.h"
#import "Bank.h"
#import "VGDataManager.h"


@interface VGTableViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation VGTableViewController



-(NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[VGDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}


-(void) getBanksFromServer {
    
    [[VGServerManager sharedManager] getBankOnSuccess:^(NSArray *banks) {
        
    } onFailure:^(NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* docunentDirectory = [pathArray objectAtIndex:0];
    
    //[self getBanksFromServer];
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
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* Identifier = @"Cell";
    
    VGCustomTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[VGCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
   // cell.delegate = self;
    //[self configureCell:cell atIndexPath:indexPath];
    return  cell;
}

- (void)configureCell:(VGCustomTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Bank *aBank = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleString = aBank.title;
    cell.regionString = aBank.region;
    cell.cityString = aBank.city;
    cell.phoneString = aBank.phone;
    cell.addressString = aBank.address;
    [cell awakeFromNib];

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


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bank" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil/*@"Master"*/];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

@end
