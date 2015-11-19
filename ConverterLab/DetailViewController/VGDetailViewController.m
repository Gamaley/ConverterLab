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
#import "VGModalViewController.h"
#import "VGMapAnnotation.h"
#import "VGMapViewController.h"



@interface VGDetailViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailInfoView;
@property (weak, nonatomic) IBOutlet UIView *nameCurrencyView;
@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *hamburgerMenuView;
@property (weak, nonatomic) IBOutlet UIButton *hamburgerButton;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) VGModalViewController *modal;


@end

@implementation VGDetailViewController
- (IBAction)mapAction:(UIButton *)sender {
    VGMapViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VGMapViewController"];
    vc.mapAnnotation = self.mapAnnotation;
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)linkAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkString]];
}

- (IBAction)phoheAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneString]]];
}

- (IBAction)optionsActionHamburger:(UIButton *)sender {
    if (self.hamburgerMenuView.isHidden) {
        [self.hamburgerButton setSelected:YES];
        [self.hamburgerMenuView setHidden: NO];
    } else {
        [self.hamburgerMenuView setHidden: YES];
        [self.hamburgerButton setSelected:NO];
    }
    
}

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
    //[self setModalPresentationStyle:UIModalPresentationCurrentContext];
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
    
    self.hamburgerButton.layer.shadowOffset = CGSizeMake(1, 0);
    self.hamburgerButton.layer.cornerRadius = self.hamburgerButton.frame.size.width/2;
    self.hamburgerButton.layer.shadowRadius = 5;
    self.hamburgerButton.layer.shadowOpacity = .25;
    
    self.mapButton.layer.shadowOffset = CGSizeMake(1, 0);
    self.mapButton.layer.cornerRadius = self.hamburgerButton.frame.size.width/2;
    self.mapButton.layer.shadowRadius = 5;
    self.mapButton.layer.shadowOpacity = .25;
    
    self.linkButton.layer.shadowOffset = CGSizeMake(1, 0);
    self.linkButton.layer.cornerRadius = self.hamburgerButton.frame.size.width/2;
    self.linkButton.layer.shadowRadius = 5;
    self.linkButton.layer.shadowOpacity = .25;

    self.phoneButton.layer.shadowOffset = CGSizeMake(1, 0);
    self.phoneButton.layer.cornerRadius = self.hamburgerButton.frame.size.width/2;
    self.phoneButton.layer.shadowRadius = 5;
    self.phoneButton.layer.shadowOpacity = .25;

    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
   // self.currencyArray = [[NSMutableArray alloc] init];
}

-(void) shareAction: (UIBarButtonItem *) sender {
    
    /*
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"iOS programming is so fun!";
    // To address
    //NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    //[mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
 */
    
    self.modal = [self.storyboard instantiateViewControllerWithIdentifier:@"VGModalViewController"];
    //UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HalfModal"];
    //vc.view.backgroundColor = [UIColor redColor];
    //[VGDetailViewController setPresentationStyleForSelfController:self presentingController:self.modal];
    //[self setModalPresentationStyle:UIModalPresentationCurrentContext];
   // self.modalPresentationCapturesStatusBarAppearance = NO;
    //self.modal.providesPresentationContextTransitionStyle = YES;
    //self.modal.definesPresentationContext = YES;
    [self.modal setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    self.modal.titleString = self.titleString;
    self.modal.regionString = self.regionString;
    self.modal.cityString = self.cityString;
    self.modal.linkString = self.linkString;
    
    for (Currency* i in self.currencyArray) {
        if ([i.engName isEqualToString:@"USD"]) {
            self.modal.usdCurrencyString = [NSString stringWithFormat:@"%1.2f/%1.2f",[i.bid doubleValue],[i.ask doubleValue]];
        }
        if ([i.engName isEqualToString:@"EUR"]) {
            self.modal.eurCurrencyString = [NSString stringWithFormat:@"%1.2f/%1.2f",[i.bid doubleValue],[i.ask doubleValue]];
        }
        if ([i.engName isEqualToString:@"RUB"]) {
            self.modal.rubCurrencyString = [NSString stringWithFormat:@"%1.2f/%1.2f",[i.bid doubleValue],[i.ask doubleValue]];
        }
    }
    //self.modal.usdCurrencyString
// 859364184080 модуль лэвун
//    self.providesPresentationContextTransitionStyle = YES;
//    self.definesPresentationContext = YES;
//    
//    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];

    //[self.navigationController popToViewController:self.modal animated:YES];
    [self presentViewController:self.modal animated:YES completion:^{}];
   // UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(self.detailInfoView.frame.origin.x + 10, self.detailInfoView.frame.origin.y + 100, self.detailInfoView.frame.size.width - 20, self.detailInfoView.frame.size.height + 100)];
    //contentView.backgroundColor = [UIColor blackColor];
    //[self.view addSubview:contentView];//[[UIView alloc] initWithFrame: CGRectMake(10, 80, self.view.size.width-20, self.view.size.height-200)];
    //[self.navigationController.view addSubview:contentView];
//    self.modal = [self.storyboard instantiateViewControllerWithIdentifier:@"HalfModal"];
//
//    
//    if ([self.childViewControllers count] == 0) {
//        self.modal = [self.storyboard instantiateViewControllerWithIdentifier:@"HalfModal"];
//        self.modal.view.frame = CGRectMake(0, 400, 320, 280);
//        [self.view addSubview:self.modal.view];
//        [self.presentingViewController addChildViewController:self.modal];
//
//        [self presentViewController:self.modal animated:YES completion:^{
//            [self.modal didMoveToParentViewController:self];
//        }];
    
//    [self transitionFromViewController:self toViewController:self.modal duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//        [self transitionFromViewController:self toViewController:self.modal duration:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
//            self.modal.view.frame = CGRectMake(0, 250, 320, 280);
//        } completion:^(BOOL finished) {
//            [self.modal didMoveToParentViewController:self];
//        }];
    
//        [UIView animateWithDuration:1 animations:^{
//            
//        } completion:^(BOOL finished) {
//            [self.modal didMoveToParentViewController:self];
//        }];
//    } else {
//        [UIView animateWithDuration:1 animations:^{
//            self.modal.view.frame = CGRectMake(0, 400, 320, 280);
//        } completion:^(BOOL finished) {
//            [self.modal.view removeFromSuperview];
//            [self.modal removeFromParentViewController];
//            self.modal = nil;
//        }];
   // }
   
   // NSLog(@"dfsfs");
}

//+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
//{
//    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
//    {
//        //iOS 8.0 and above
//        presentingController.providesPresentationContextTransitionStyle = YES;
//        presentingController.definesPresentationContext = YES;
//        
//        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
//    }
//    else
//    {
//        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
//        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
//    }
//}



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
