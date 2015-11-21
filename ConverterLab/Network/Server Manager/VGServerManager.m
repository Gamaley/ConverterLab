//
//  VGServerManager.m
//  ConverterLab
//
//  Created by Vladyslav on 12.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGServerManager.h"
#import "AFNetworking.h"
#import "City.h"
#import "Region.h"
#import "Bank.h"
#import "VGDataManager.h"
#import "Reachability.h"
#import "Currency.h"
#import "VGLoginViewController.h"
#import "VGAccessToken.h"

@interface VGServerManager ()

@property (strong, nonatomic) VGAccessToken *accessToken;

@end



@implementation VGServerManager

+(VGServerManager*) sharedManager {
    
    static VGServerManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VGServerManager alloc] init];
    });
    
    return manager;
}



-(void) authorizeUserWithController: (UIViewController *) controller andCompletitionBlock: (void (^) (VGAccessToken *userToken)) completition {
    
    VGLoginViewController *vc = [[VGLoginViewController alloc] initWithCompletitionBlock:^(VGAccessToken *token) {
        
        if (token) {
        self.accessToken = token;
        }
        
        if (completition) {
            self.tokenExist = YES;
            completition(self.accessToken);
        }
        
    }];
    
    [controller presentViewController:vc animated:YES completion:nil];

}



-(void) getBankOnSuccess:(void(^)(id banks)) success onFailure:(void(^)(NSError* error)) failure {
    
    static NSString *getBanksJSON = @"http://resources.finance.ua/ru/public/currency-cash.json";
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];

    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        return;
    }
    
    [[VGDataManager sharedManager] deleteEntitiesFromDataBase];
    
    [manager GET:getBanksJSON parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {
        
        
        if (success) {
     
            NSMutableSet *citySet = [[NSMutableSet alloc] init];
             NSMutableSet *regionSet = [[NSMutableSet alloc] init];
    
            NSDictionary *currencyDictionary = [responseObject objectForKey:@"currencies"];
          

            for (NSDictionary* i in [responseObject objectForKey:@"organizations"]) {
                
                Bank *aBank = [NSEntityDescription insertNewObjectForEntityForName:@"Bank" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
                
                NSDictionary *currenciesDictionary = [i valueForKey:@"currencies"];
                
                
                for (NSString* value in [currenciesDictionary allKeys]) {
                    Currency *aCurrency = [NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
                    
                    NSString *currencyName = [[currencyDictionary valueForKey:value] capitalizedString];
                    double ask = [[[[i valueForKey:@"currencies"] valueForKey:value] valueForKey:@"ask"] doubleValue];
                    double bid = [[[[i valueForKey:@"currencies"] valueForKey:value] valueForKey:@"bid"] doubleValue];
                    aCurrency.engName = value;
                    aCurrency.name = currencyName;
                    aCurrency.ask = @(ask);
                    aCurrency.bid = @(bid);
                    [aBank addCurrenciesObject:aCurrency];
                }
                
                aBank.city = [[responseObject objectForKey:@"cities"] valueForKey:[i valueForKey:@"cityId"]];
                aBank.region = [[responseObject objectForKey:@"regions"] valueForKey:[i valueForKey:@"regionId"]];
                aBank.link = [i valueForKey:@"link"];
            
                if (![[i valueForKey:@"phone"] isEqual:[NSNull null]]) {
                   //NSLog(@"%@",str);
                     aBank.phone = [i valueForKey:@"phone"];
                }
                
                aBank.address = [i valueForKey:@"address"];
                aBank.title = [i valueForKey:@"title"];
                
                
                if (![citySet containsObject:aBank.city]) {
                    
                      City *aCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
                    
                    [citySet addObject:aBank.city];
             
                    aCity.name = aBank.city;
                    [aBank addCitiesObject:aCity];
                    
                }
                
                if (![regionSet containsObject:aBank.region]) {
                    
                    Region *aRegion = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
                    
                    [regionSet addObject:aBank.region];
                    
                    aRegion.name = aBank.region;
                    [aRegion addCities:aBank.cities];
                    
                }
                
                NSError* error = nil;
                if (![[VGDataManager sharedManager].managedObjectContext save:&error]) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                
            }
            success(@"Success");
        }
        
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"%@",error);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}



-(void) postText:(NSString *) text onMyWallVKOnSuccess:(void(^)(id result)) success onFailure:(void(^)(NSError* error)) failure {
    
    NSDictionary *params = @{@"owner_id": self.accessToken.userID, @"message" : text, @"access_token" : self.accessToken.token};
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSString *postString = @"https://api.vk.com/method/wall.post";
    
    [manager POST:postString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

@end
