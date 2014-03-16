//
//  Constants.h
//  HaiXiuGroup
//
//  Created by zhang on 14-3-14.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#define DOUBAN_API_URL @"http://api.douban.com"

#define IOS7_NAVGATION_BAR_COLOR                         [UIColor colorWithRed:0 green:108.0 / 255.0 blue:174.0 / 255.0 alpha:IOS7_ALPHA]
#define IOS6_NAVGATION_BAR_COLOR                         [UIColor colorWithRed:0 green:108.0 / 255.0 blue:174.0 / 255.0 alpha:1]

#define IOS7_ALPHA                                  0.9
#define IOS7_TOOL_BAR_BACKGROUND_COLOR              [UIColor colorWithRed:251.0 / 255.0 green:251.0 / 255.0 blue:251.0 / 255.0 alpha:IOS7_ALPHA]
#define IOS6_TOOL_BAR_BACKGROUND_COLOR              [UIColor colorWithRed:251.0 / 255.0 green:251.0 / 255.0 blue:251.0 / 255.0 alpha:0.9]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define ISPHONE5 (CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) ? YES : NO)
#define ISRETINA ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)  || ISPHONE5) : NO)