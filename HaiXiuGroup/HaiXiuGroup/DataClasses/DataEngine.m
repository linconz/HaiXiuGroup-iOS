//
//  DataEngine.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-14.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "DataEngine.h"
#import "ASIHTTPRequest.h"
#import "Constants.h"
#import "Constants+APIRequest.h"
#import "Constants+ErrorCodeDef.h"
#import "JSONKit.h"
#import "ErrorCodeUtils.h"

#import "DataParse.h"

#import "User.h"
#import "Topic.h"

@implementation DataEngine

@synthesize topics = _topics;

static DataEngine *dataEngine = nil;

+ (DataEngine *)sharedDataEngine
{
	@synchronized(dataEngine) {
		if (!dataEngine) {
			dataEngine = [[self alloc] init];
		}
	}
	return dataEngine;
}

- (DataEngine *)init
{
	self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        _topics = [[NSMutableArray alloc] init];
    }
	return self;
}

- (void)getGroupTopicsReceived:(ASIHTTPRequest *)request
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    NSDictionary *requestInfo = [request userInfo];
    NSString *notificationName = [requestInfo objectForKey:NOTIFICATION_NAME];
    [result setValue:[requestInfo objectForKey:REQUEST_SOURCE_KEY] forKey:REQUEST_SOURCE_KEY];
    if (![request error]) {
        NSData *data = [request responseData];
        NSDictionary *dict = [data objectFromJSONData];
        NSArray *topicsArray = [dict objectForKey:@"topics"];
        // 豆瓣返回的东西也没有个返回状态的标识,所以先用是否返回tpoics作为数据验证
        if (topicsArray && [topicsArray isKindOfClass:[NSArray class]]) {
            if ([[requestInfo objectForKey:@"startPage"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                [_topics removeAllObjects];
            }
            for (int i=0; i<[topicsArray count]; i++) {
                NSDictionary *topicDict = [topicsArray objectAtIndex:i];
                Topic *topic = [[Topic alloc] init];
                [DataParse createTopicFromRemoteData:topic remoteData:topicDict];
                [_topics addObject:topic];
            }
            [result setObject:[NSNumber numberWithInt:0] forKey:RETURN_CODE];
        } else {
            [result setObject:[NSNumber numberWithInt:-2] forKey:RETURN_CODE];
            [result setObject:[ErrorCodeUtils errorDetailFromErrorCode:-2]
                       forKey:TOUI_REQUEST_ERROR_MESSAGE];
        }
    } else {
        // 服务器错误
        [result setObject:[NSNumber numberWithInt:-1] forKey:RETURN_CODE];
        [result setObject:[ErrorCodeUtils errorDetailFromErrorCode:-1]
                   forKey:TOUI_REQUEST_ERROR_MESSAGE];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:nil
                                                      userInfo:result];
}

- (void)getGroupTopics:(NSNumber *) startPage
              pageSize:(NSNumber *) pageSize
                source:(NSString *) source
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", DOUBAN_API_URL, REQUEST_HAIXIUZU_TOPICS];
    urlString = [urlString stringByAppendingFormat:@"?start=%lld", (startPage ? [startPage longLongValue] : 0)];
    urlString = [urlString stringByAppendingFormat:@"&count=%lld", (pageSize ? [pageSize longLongValue] : 0)];
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    NSDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[[NSProcessInfo processInfo] globallyUniqueString]
                  forKey:@"id"];
    [dictionary setValue:source
                  forKey:REQUEST_SOURCE_KEY];
    [dictionary setValue:REQUEST_HAIXIUZU_TOPICS
                  forKey:NOTIFICATION_NAME];
    [dictionary setValue:startPage forKey:@"startPage"];
    [dictionary setValue:pageSize forKey:@"pageSize"];
    [request setUserInfo:dictionary];
    [request startAsynchronous];
}

#pragma mark ASIHttpRequest回调

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *notificationName = [[request userInfo] valueForKeyPath:NOTIFICATION_NAME];
    if ([notificationName isEqualToString:REQUEST_HAIXIUZU_TOPICS]) {
        [self getGroupTopicsReceived:request];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *notificationName = [request valueForKey:@"name"];
    if ([notificationName isEqualToString:REQUEST_HAIXIUZU_TOPICS]) {
        [self getGroupTopicsReceived:request];
    }
}
@end
