//
//  City+CoreDataProperties.h
//  ConverterLab
//
//  Created by Vladyslav on 12.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface City (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *banks;
@property (nullable, nonatomic, retain) Region *region;

@end

@interface City (CoreDataGeneratedAccessors)

- (void)addBanksObject:(NSManagedObject *)value;
- (void)removeBanksObject:(NSManagedObject *)value;
- (void)addBanks:(NSSet<NSManagedObject *> *)values;
- (void)removeBanks:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
