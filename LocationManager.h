//
//  LocationManager.h
//  mapTest
//
//  Created by Chenyun on 15/3/11.
//  Copyright (c) 2015年 geek-zoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) NSMutableArray * locationArray;

@property (nonatomic, strong) CLGeocoder * geoCoder;

@property (nonatomic, copy) void (^whenGetLoaction)( id );
@property (nonatomic, copy) void (^whenGetReverseGeocoding)( id );

- (void)locationOpen;
- (void)locationStop;
+ (LocationManager *)sharedManager;
- (void)reverseGeocoding;

- (void)locationWithPlaceName:(NSString *)placename;

@end