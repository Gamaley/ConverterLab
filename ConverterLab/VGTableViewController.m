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


@interface VGTableViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate,UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UISearchBar* searchBar;
@property (strong, nonatomic) UISearchController* searchController;
@property (strong,nonatomic) NSString* searchString;

@end

@implementation VGTableViewController


-(IBAction)showSearchBar:(id)sender {
    [self getSearchBar];
    
}


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
    cell.linkString = aBank.link;
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
    
    if (self.searchController.isActive) {
        NSString *titleString = self.searchController.searchBar.text;
        NSString *regionString = self.searchController.searchBar.text;
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"city contains[cd] %@ OR title contains[cd] %@ OR region contains[cd] %@",self.searchController.searchBar.text, titleString,regionString];
        [fetchRequest setPredicate:predicate];
    }
    
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



-(void)getSearchBar
{
    if (!self.searchBar) {
        self.searchBar = [[UISearchBar alloc] init];
        
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchController.searchResultsUpdater = self;
        self.searchController.searchBar.delegate = self;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        self.searchController.searchBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        self.searchController.searchBar.barStyle = UISearchBarStyleMinimal;
    }
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.tableView reloadData];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.fetchedResultsController = nil;
    [self.searchController setActive:NO];
    [self fetchedResultsController];
    self.tableView.tableHeaderView = nil;
    [self.tableView reloadData];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.fetchedResultsController = nil;
    [self fetchedResultsController];
    self.searchString = searchText;
    NSLog(@"%@",self.searchString);
    [self.tableView reloadData];
    
}

@end
