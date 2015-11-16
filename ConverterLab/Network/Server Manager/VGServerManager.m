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

//-(void) deleteEntitiesFromDataBase {
//    NSFetchRequest *regionRequest = [[NSFetchRequest alloc] initWithEntityName:@"Region"];
//    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:regionRequest];
//    NSError *error = nil;
//    NSPersistentStoreCoordinator *persistentStoreCoordinator = [VGDataManager sharedManager].persistentStoreCoordinator;
//    [persistentStoreCoordinator executeRequest:delete withContext:[VGDataManager sharedManager].managedObjectContext error:&error];
//}

-(void) getBankOnSuccess:(void(^)(NSArray* banks)) success onFailure:(void(^)(NSError* error)) failure {
    
    static NSString *getBanksJSON = @"http://resources.finance.ua/ru/public/currency-cash.json";
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
//    NSError *error = nil;
//    NSPersistentStore *store = [[NSPersistentStore alloc] initWithPersistentStoreCoordinator:[VGDataManager sharedManager].persistentStoreCoordinator configurationName:nil URL:[[VGDataManager sharedManager] applicationDocumentsDirectory] options:nil];
//    [[VGDataManager sharedManager].persistentStoreCoordinator removePersistentStore:store error:&error];
//    
//    error = nil;
//    [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:&error];
    
    [manager GET:getBanksJSON parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {
        
        
        NSArray *banksArray = [responseObject objectForKey:@"organizations"];
      
        
        if (success) {
            
            //[[VGDataManager sharedManager] deleteEntitiesFromDataBase];
            
            NSMutableSet *citySet = [[NSMutableSet alloc] init];
             NSMutableSet *regionSet = [[NSMutableSet alloc] init];
            
            
            for (NSDictionary* i in [responseObject objectForKey:@"organizations"]) {
                

                Bank *aBank = [NSEntityDescription insertNewObjectForEntityForName:@"Bank" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
              
                

                
                
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




// NSDictionary *citiesArray = [responseObject objectForKey:@"cities"];
// NSDictionary *regionsArray = [responseObject objectForKey:@"regions"];

// NSString* cityNameID = [[banksArray objectAtIndex:0] valueForKey:@"cityId"];
// NSString *cityName = [citiesArray valueForKey:cityNameID];


//NSMutableArray *regionNames = [[NSMutableArray alloc] init]; //[[regionsArray objectAtIndex:0]allValues ];

//NSArray *citiesArray = [[responseObject objectForKey:@"cities"] allValues];



// for (NSDictionary* i in [responseObject objectForKey:@"cities"]) {
//Region *aRegion = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManage:[dObjectContext:[VGDataManager sharedManager].managedObjectContext];
// NSArray *arr = [i allValues];
//            [regionNames addObjectsFromArray:arr];

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
//   }

// NSLog(@"%@",responseObject);


//        NSSet *citiesSet = [NSSet setWithArray:[[responseObject objectForKey:@"cities"] allValues]];
//
//        NSSet *regionsSet = [NSSet setWithArray:[[responseObject objectForKey:@"regions"] allValues]];
//
//        int count = 0;


//                [citySet addObject:aCity.name];
//                [regionSet addObject:aRegion.name];

//                Region *aRegion = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
//                City *aCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
  // City *aCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];


//[aRegion addCitiesObject:[aBank.cities ];
//[aBank addCitiesObject:aRegion];


//            Bank *aBank = [NSEntityDescription insertNewObjectForEntityForName:@"Bank" inManagedObjectContext:[VGDataManager sharedManager].managedObjectContext];
//
//            aBank.cities = citySet;
//
//            NSError* error = nil;
//            if (![[VGDataManager sharedManager].managedObjectContext save:&error]) {
//                NSLog(@"%@",[error localizedDescription]);
//            }
//                aCity.name = [[responseObject objectForKey:@"cities"] valueForKey:[i valueForKey:@"cityId"]];
//                aRegion.name = [[responseObject objectForKey:@"regions"] valueForKey:[i valueForKey:@"regionId"]];

//                [aRegion addCitiesObject:aCity];
//                [aBank addCitiesObject:aCity];


