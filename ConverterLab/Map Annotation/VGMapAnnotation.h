//
//  VGMapAnnotation.h
//  ConverterLab
//
//  Created by Vladyslav on 16.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface VGMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr;

@end
