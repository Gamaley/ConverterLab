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

@interface VGDetailViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailInfoView;
@property (weak, nonatomic) IBOutlet UIView *nameCurrencyView;
@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation VGDetailViewController

-(NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[VGDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingsView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

-(void) settingsView {
    
    self.detailInfoView.layer.masksToBounds = NO;
    self.detailInfoView.layer.shadowOffset = CGSizeMake(-2, 4);
    self.detailInfoView.layer.shadowRadius = 3;
    self.detailInfoView.layer.shadowOpacity = 0.5;
    
    self.nameCurrencyView.layer.masksToBounds = NO;
    self.nameCurrencyView.layer.shadowOffset = CGSizeMake(-2, 4);
    self.nameCurrencyView.layer.shadowRadius = 3;
    self.nameCurrencyView.layer.shadowOpacity = 0.5;
    
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
    
//    if (self.searchController.isActive) {
//        NSString *titleString = self.searchController.searchBar.text;
//        NSString *regionString = self.searchController.searchBar.text;
//        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"city contains[cd] %@ OR title contains[cd] %@ OR region contains[cd] %@",self.searchController.searchBar.text, titleString,regionString];
//        [fetchRequest setPredicate:predicate];
//    }
    
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* Identifier = @"DetailCell";
    VGDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[VGDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    //cell.delegate = self;
   // [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(VGDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
//    Bank *aBank = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.titleString = aBank.title;
//    cell.regionString = aBank.region;
//    cell.cityString = aBank.city;
//    cell.phoneString = aBank.phone;
//    cell.addressString = aBank.address;
//    cell.linkString = aBank.link;
    [cell awakeFromNib];
    
}


@end
