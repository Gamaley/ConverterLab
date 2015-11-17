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

@interface VGDetailViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailInfoView;
@property (weak, nonatomic) IBOutlet UIView *nameCurrencyView;
@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
   // self.currencyArray = [[NSMutableArray alloc] init];
}

-(void) shareAction: (UIBarButtonItem *) sender {
    NSLog(@"dfsfs");
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
    //id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [self.currencyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* Identifier = @"DetailCell";
    VGDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[VGDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    //cell.delegate = self;
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
