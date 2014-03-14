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
#import "JSONKit.h"

@implementation DataEngine

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
    }
	return self;
}

- (void)getGroupTopicsReceived:(ASIHTTPRequest *)request
{
    if (![request error]) {
        NSData *data = [request responseData];
        NSDictionary *dict = [data objectFromJSONData];
        NSDictionary *topic = [[dict objectForKey:@"topics"] objectAtIndex:0];
        NSLog(@"content:%@", [topic objectForKey:@"content"]);
        NSLog(@"alt:%@", [topic objectForKey:@"alt"]);
    } else {
        
    }
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
                  forKey:@"source"];
    [dictionary setValue:REQUEST_HAIXIUZU_TOPICS
                  forKey:@"name"];
    [request setUserInfo:dictionary];
    [request startAsynchronous];
}

#pragma mark ASIHttpRequest回调

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *notificationName = [[request userInfo] valueForKeyPath:@"name"];
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
