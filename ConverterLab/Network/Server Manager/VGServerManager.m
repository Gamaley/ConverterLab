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



@implementation VGServerManager

+(VGServerManager*) sharedManager {
    
    static VGServerManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VGServerManager alloc] init];
    });
    
    return manager;
}


-(void) getBankOnSuccess:(void(^)(NSArray* banks)) success onFailure:(void(^)(NSError* error)) failure {
    
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
           // NSMutableSet *currencySet = [[NSMutableSet alloc] init];
            NSDictionary *currencyDictionary = [responseObject objectForKey:@"currencies"];
          

            for (NSDictionary* i in [responseObject objectForKey:@"organizations"]) {
                
                Bank *aBank = [NSEntityDescription insertNewObjectForEntityForName:@"Bank" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
                
                NSDictionary *currenciesDictionary = [i valueForKey:@"currencies"];
                
                
                for (NSString* value in [currenciesDictionary allKeys]) {
                    Currency *aCurrency = [NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
                    
                    NSString *currencyName = [[currencyDictionary valueForKey:value] capitalizedString];
                    double ask = [[[[i valueForKey:@"currencies"] valueForKey:value] valueForKey:@"ask"] doubleValue];
                    double bid = [[[[i valueForKey:@"currencies"] valueForKey:value] valueForKey:@"bid"] doubleValue];
                    //NSLog(@"%@",currencyName);
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
            
        }
        
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"%@",error);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

@end



//                NSDictionary *valuesArray = (NSDictionary *)[dict allValues];
//                NSMutableDictionary *askBid = [[NSMutableDictionary alloc] init];
// NSDictionary *ddd = [[i valueForKey:@"currencies"] valueForKey:[valuesArray firstObject]];
// NSArray *askBid = [dict allKeys];
// for (int j = 0; j < [dict count]; j++) {

// NSString *sdtr = [currencyDictionary valueForKey:@"dict"];
//NSString* ssss = [[[i valueForKey:@"currencies"] valueForKey:@"EUR"] valueForKey:@"ask"];
// }

//                for (NSDictionary* j in [i valueForKey:@"currencies"]) {
//                    Currency *aCurrency = [NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
////                    if ([j isEqualToDictionary:[currencyDictionary objectForKey:j]] ) {
////
////                    }
//                    NSString *str = [[currencyDictionary valueForKey:j] capitalizedString];//[j valueForKey:@"currencies"];
//                    //NSString *askStr =
//                   // NSLog(@"%@",str);
//
//                    aCurrency.name = [i valueForKey:j];//[[j allKeys] objectAtIndex:<#(NSUInteger)#>]
//                    //NSDictionary *curr = [j valueForKey:[i valueForKey:@"currencies"]];
//                }
