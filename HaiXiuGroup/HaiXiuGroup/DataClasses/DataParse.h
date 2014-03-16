//
//  DataParse.h
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class Topic;

@interface DataParse : NSObject

+ (void)createTopicFromRemoteData:(Topic *) topic
                       remoteData:(NSDictionary *)remoteData;

+ (void)createUserFromRemoteData:(User *) user
                      remoteData:(NSDictionary *)remoteData;

@end
