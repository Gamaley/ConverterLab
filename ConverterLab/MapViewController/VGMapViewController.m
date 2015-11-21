//
//  VGMapViewController.m
//  ConverterLab
//
//  Created by Vladyslav on 13.11.15.
//  Copyright © 2015 Vlad. All rights reserved.
//

#import "VGMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "VGMapAnnotation.h"

@interface VGMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak,nonatomic) IBOutlet MKMapView *mapview;
@property (strong, nonatomic)  CLLocationManager *locationManager;
@end

@implementation VGMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [self.mapview setVisibleMapRect:[self getZoomMapRect] animated:YES];
    [self.mapview addAnnotation:self.mapAnnotation];
    
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark - Private

-(MKMapRect) getZoomMapRect {
    CLLocationCoordinate2D coor = self.mapAnnotation.coordinate;
    MKMapPoint center = MKMapPointForCoordinate(coor);
    
    static double delta = 20000;
    MKMapRect mapRect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
    
    return mapRect;
}


#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identifier = @"Annotation";
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.pinTintColor = [MKPinAnnotationView greenPinColor];
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
    } else {
        pin.annotation = annotation;
    }
    return pin;
}

@end
