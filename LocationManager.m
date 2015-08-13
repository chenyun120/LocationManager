//
//  LocationManager.m
//  mapTest
//
//  Created by Chenyun on 15/3/11.
//  Copyright (c) 2015年 geek-zoo. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

static LocationManager * sharedLoaction = nil;

+ (LocationManager *)sharedManager
{
	static dispatch_once_t predicate;
	
	dispatch_once(&predicate, ^{
		sharedLoaction = [[self alloc] init];
	});
	
	return sharedLoaction;
}

- (instancetype)init
{
	self = [super init];

	if ( self )
	{
		// 位置管理器
//		self.locationManager = [[CLLocationManager alloc] init];
//		self.locationManager.delegate = self;
//
//		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;  // 精度设置
//		[_locationManager requestAlwaysAuthorization];  // 始终允许访问位置数据
//		self.locationManager.distanceFilter = 10000.0f;// 每秒出发一次   //1000.0f;  // 移动1000米后更新坐标
//
//		self.locationArray = [NSMutableArray array];
	}

	return self;
}

- (void)locationOpen
{
	// 位置管理器
	if ( [CLLocationManager locationServicesEnabled] )
	{
		[_locationManager stopUpdatingLocation];
		[_locationManager startUpdatingLocation];
	}
	else
	{
		NSLog(@"定位没有开启");
	}
}

- (void)locationStop
{
	[_locationManager stopUpdatingLocation];
}

#pragma mark -
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	CLLocation * currentLocation = [locations lastObject];

	// 得到用户当前的坐标
	CLLocation * location = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];

	[self.locationArray addObject:location];

	if ( self.whenGetLoaction )
	{
		self.whenGetLoaction(self.locationArray);
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	
}

/**
 * 反编码的实现
 *
 */
- (void)reverseGeocoding
{
	if ( !self.geoCoder )
	{
        // 系统自带的 把经纬度 转换为 地址，
		self.geoCoder = [[CLGeocoder alloc] init];
	}

	// 两个block  一个用来获取当前坐标  一个用来得到当前的城市信息
	LocationManager * locationManager = [LocationManager sharedManager];

    // 当经纬度获取到，就调这个Block
	locationManager.whenGetLoaction = ^( NSMutableArray * locations )
	{
        CLLocation * currentLocation = [locations lastObject];
        NSLog(@"====loc--%@",currentLocation);

		[self.geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {

            NSLog(@"=====%@",placemarks);
			if ( placemarks.count )
			{
				// 获取城市信息成功
				CLPlacemark * placeMark = [placemarks lastObject];
				if ( self.whenGetReverseGeocoding )
				{
					self.whenGetReverseGeocoding(placeMark);
				}
			}
			else
			{
				// 获取城市信息失败
				[[YCRootViewController sharedInstance] presentFailureTips:@"获取城市信息失败"];
			}
		}];
	};

    // 开始获取经纬度
	[locationManager locationOpen];
}

- (void)locationWithPlaceName:(NSString *)placename
{
	CLGeocoder * gecoder = [[CLGeocoder alloc] init];

	[gecoder geocodeAddressString:placename completionHandler:^(NSArray *placemarks, NSError *error) {
		if ( self.whenGetLoaction )
		{
			CLPlacemark * placeMark = [placemarks lastObject];
			self.whenGetLoaction(placeMark);
		}
	}];
}

@end