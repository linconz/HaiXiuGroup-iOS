//
//  DataParse.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "DataParse.h"
#import "User.h"
#import "Topic.h"

@implementation DataParse

+ (void)createTopicFromRemoteData:(Topic *) topic
                       remoteData:(NSDictionary *)remoteData
{
    if (topic == nil) {
        return;
    }
    NSString *topicId = [remoteData objectForKey:@"id"];
    if (topicId && [topicId isKindOfClass:[NSString class]] && [topicId length] > 0) {
        topic.topicId = topicId;
    }
    NSString *alt = [remoteData objectForKey:@"alt"];
    if (alt && [alt isKindOfClass:[NSString class]] && [alt length] > 0) {
        topic.alt = alt;
    }
    NSString *title = [remoteData objectForKey:@"title"];
    if (title && [title isKindOfClass:[NSString class]] && [title length] > 0) {
        topic.title = title;
    }
    NSString *content = [remoteData objectForKey:@"content"];
    if (content && [content isKindOfClass:[NSString class]] && [content length] > 0) {
        topic.content = content;
    }
    NSNumber *likeCount = [remoteData objectForKey:@"like_count"];
    if (likeCount && [likeCount isKindOfClass:[NSNumber class]]) {
        topic.likeCount = likeCount;
    }
    NSNumber *commentsCount = [remoteData objectForKey:@"comments_count"];
    if (commentsCount && [commentsCount isKindOfClass:[NSNumber class]]) {
        topic.commentsCount = commentsCount;
    }
    User *author = [[User alloc] init];
    NSDictionary *user = [remoteData objectForKey:@"author"];
    if (user && [user isKindOfClass:[NSDictionary class]]) {
        [self createUserFromRemoteData:author remoteData:user];
        topic.author = author;
    }
    NSString *createdString = [remoteData objectForKey:@"created"];
    if (createdString && [createdString isKindOfClass:[NSString class]]) {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
        NSDate *created = [formater dateFromString:createdString];
        topic.created = created;
    }
    NSString *updatedString = [remoteData objectForKey:@"updated"];
    if (updatedString && [updatedString isKindOfClass:[NSString class]]) {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
        NSDate *updated = [formater dateFromString:updatedString];
        topic.updated = updated;
    }
    NSArray *photosDict = [remoteData objectForKey:@"photos"];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    if (photosDict && [photosDict isKindOfClass:[NSMutableArray class]] && [photosDict count] > 0) {
        for (int i=0; i<[photosDict count]; i++) {
            NSDictionary *photoItem = [photosDict objectAtIndex:i];
            [photos addObject:[photoItem objectForKey:@"alt"]];
        }
    }
    topic.photos = [[NSMutableArray alloc] initWithArray:photos];
}

+ (void)createUserFromRemoteData:(User *) user
                      remoteData:(NSDictionary *)remoteData
{
    if (user == nil) {
        return;
    }
    NSString *userId = [remoteData objectForKey:@"uid"];
    if (userId && [userId isKindOfClass:[NSString class]] && [userId length] > 0) {
        user.userId = userId;
    }
    NSString *alt = [remoteData objectForKey:@"alt"];
    if (alt && [alt isKindOfClass:[NSString class]] && [alt length] > 0) {
        user.alt = alt;
    }
    NSString *name = [remoteData objectForKey:@"name"];
    if (name && [name isKindOfClass:[NSString class]] && [name length] > 0) {
        user.name = name;
    }
    NSString *avatar = [remoteData objectForKey:@"avatar"];
    if (avatar && [avatar isKindOfClass:[NSString class]] && [avatar length] > 0) {
        user.avatar = avatar;
    }
    NSNumber *isSuicide = [NSNumber numberWithInt:[[remoteData objectForKey:@"is_suicide"] intValue]];
    if (isSuicide && [isSuicide isKindOfClass:[NSNumber class]]) {
        user.isSuicide = [isSuicide boolValue];
    }
}

@end
