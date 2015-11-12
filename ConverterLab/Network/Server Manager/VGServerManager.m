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
    
    
    [manager GET:getBanksJSON parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {
        
             Region *aRegion = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
        
        NSArray *banksArray = [responseObject objectForKey:@"organizations"];
        NSArray *citiesArray = [responseObject objectForKey:@"cities"];
        NSArray *regionsArray = [responseObject objectForKey:@"regions"];
        
//        for (NSDictionary* i in regionsArray) {
//            
//           
//            
//            
//        }
        
        NSLog(@"%@",responseObject);
        
        if (success) {
            
            Bank *aBank = [NSEntityDescription insertNewObjectForEntityForName:@"Bank" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
            City *aCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
       
            
           // aBank.cities = aCity;
            
            [aRegion addCitiesObject:aCity];
            [aCity addBanksObject:aBank];
            
            success(banksArray);
        }
        
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"%@",error);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}


@end
