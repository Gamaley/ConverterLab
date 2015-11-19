//
//  Currency+CoreDataProperties.h
//  ConverterLab
//
//  Created by Vladyslav on 17.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Currency.h"

NS_ASSUME_NONNULL_BEGIN

@interface Currency (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *engName;
@property (nullable, nonatomic, retain) NSNumber *ask;
@property (nullable, nonatomic, retain) NSNumber *bid;
@property (nullable, nonatomic, retain) Bank *bank;

@end

NS_ASSUME_NONNULL_END
