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
        
             City *aCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
        
        
        NSArray *banksArray = [responseObject objectForKey:@"organizations"];
       // NSDictionary *citiesArray = [responseObject objectForKey:@"cities"];
       // NSDictionary *regionsArray = [responseObject objectForKey:@"regions"];
        
       // NSString* cityNameID = [[banksArray objectAtIndex:0] valueForKey:@"cityId"];
       // NSString *cityName = [citiesArray valueForKey:cityNameID];
        
        
//        NSMutableArray *regionNames = [[NSMutableArray alloc] init]; //[[regionsArray objectAtIndex:0]allValues ];
        
        for (NSDictionary* i in [responseObject objectForKey:@"organizations"]) {
//
//            NSString *cityName = [[responseObject objectForKey:@"cities"] valueForKey:[i valueForKey:@"cityId"]];
//            NSString *region = [[responseObject objectForKey:@"regions"] valueForKey:[i valueForKey:@"regionId"]];
//            NSString *link = [i valueForKey:@"link"];
     //       NSDecimalNumber *phoneNumber = [i valueForKey:@"phone"];
       //     NSString* str = [i valueForKey:@"phone"];
//            NSString *address = [i valueForKey:@"address"];
//            NSString *title = [i valueForKey:@"title"];
//            
         //   NSLog(@"d");
//          //  [regionNames addObject:[i allValues]];
//    
      }
        
       // NSLog(@"%@",responseObject);
        
        if (success) {
            
            for (NSDictionary* i in [responseObject objectForKey:@"organizations"]) {
                
                Bank *aBank = [NSEntityDescription insertNewObjectForEntityForName:@"Bank" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
                
                aBank.city = [[responseObject objectForKey:@"cities"] valueForKey:[i valueForKey:@"cityId"]];
                aBank.region = [[responseObject objectForKey:@"regions"] valueForKey:[i valueForKey:@"regionId"]];
                aBank.link = [i valueForKey:@"link"];
                
                if (![[i valueForKey:@"phone"] isEqual:[NSNull null]]) {
                   //NSLog(@"%@",str);
                     aBank.phone = [i valueForKey:@"phone"];
                }
                //[i valueForKey:@"phone"];
                aBank.address = [i valueForKey:@"address"];
                aBank.title = [i valueForKey:@"title"];
                
                
                NSError* error = nil;
                if (![[VGDataManager sharedManager].managedObjectContext save:&error]) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                
            }
            
      
            
       
       
            
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
