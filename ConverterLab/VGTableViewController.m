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
#import "VGMapViewController.h"
#import "City.h"
#import "Region.h"
#import "Bank.h"
#import "VGDataManager.h"
#import "VGMapAnnotation.h"



@interface VGTableViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate,UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating,VGCustomTableViewCellDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSString *searchString;

@end

@implementation VGTableViewController


-(IBAction)showSearchBar:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
    [self getSearchBar];
    }];
}


-(NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[VGDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}


#pragma mark - UIViewController

-(void)loadView {
    [super loadView];
    [[VGServerManager sharedManager] getBankOnSuccess:^(NSArray *banks) {} onFailure:^(NSError *error) {}];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docunentDirectory = [pathArray objectAtIndex:0];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    cell.delegate = self;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


#warning Удалить UITabBarDelegate didSelectItem

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

#pragma mark - Private


-(void) cellOpenMapAnnotation: (VGCustomTableViewCell*) cell {
    VGMapAnnotation *annotation = [[VGMapAnnotation alloc] init];
    
    NSIndexPath* noteIndex = [self.tableView indexPathForCell:cell];
    Bank* bank = [self.fetchedResultsController objectAtIndexPath:noteIndex];
    NSString* address = [NSString stringWithFormat:@"%@ %@",bank.city, bank.address];
    VGMapViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VGMapViewController"];
    annotation.coordinate = [annotation getLocationFromAddressString:address];
    annotation.title = bank.title;
    annotation.subtitle = bank.address;
    vc.mapAnnotation = annotation;
    
    [self.navigationController pushViewController:vc animated:YES];
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


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bank" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    if (self.searchController.isActive) {
        NSString *titleString = self.searchController.searchBar.text;
        NSString *regionString = self.searchController.searchBar.text;
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"city contains[cd] %@ OR title contains[cd] %@ OR region contains[cd] %@",self.searchController.searchBar.text, titleString,regionString];
        [fetchRequest setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil/*@"Master"*/];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
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

#pragma mark - UISearchResultsUpdating

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
    [self.tableView reloadData];
    
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


@end
