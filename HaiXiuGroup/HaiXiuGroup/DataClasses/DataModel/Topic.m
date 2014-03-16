//
//  Topic.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "Topic.h"
#import "User.h"

@implementation Topic

@synthesize topicId         = _topicId;
@synthesize alt             = _alt;
@synthesize title           = _title;
@synthesize content         = _content;
@synthesize likeCount       = _likeCount;
@synthesize commentsCount   = _commentsCount;
@synthesize author          = _author;
@synthesize created         = _created;
@synthesize updated         = _updated;
@synthesize photos          = _photos;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if(self){
        self.topicId        = [coder decodeObjectForKey:@"topicId"];
        self.alt            = [coder decodeObjectForKey:@"alt"];
        self.title          = [coder decodeObjectForKey:@"title"];
        self.content        = [coder decodeObjectForKey:@"content"];
        self.likeCount      = [coder decodeObjectForKey:@"likeCount"];
        self.commentsCount  = [coder decodeObjectForKey:@"commentsCount"];
        self.author         = [coder decodeObjectForKey:@"author"];
        self.created        = [coder decodeObjectForKey:@"created"];
        self.updated        = [coder decodeObjectForKey:@"updated"];
        self.photos         = [coder decodeObjectForKey:@"photos"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.topicId forKey:@"topicId"];
    [coder encodeObject:self.alt forKey:@"alt"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.content forKey:@"content"];
    [coder encodeObject:self.likeCount forKey:@"likeCount"];
    [coder encodeObject:self.commentsCount forKey:@"commentsCount"];
    [coder encodeObject:self.author forKey:@"author"];
    [coder encodeObject:self.created forKey:@"created"];
    [coder encodeObject:self.updated forKey:@"updated"];
    [coder encodeObject:self.photos forKey:@"photos"];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    Topic *topic = [[Topic alloc] init];
    topic.topicId = self.topicId;
    topic.alt = self.alt;
    topic.content = self.content;
    topic.likeCount = self.likeCount;
    topic.commentsCount = self.commentsCount;
    topic.author = self.author;
    topic.created = self.created;
    topic.updated = self.updated;
    topic.photos = self.photos;
    return topic;
}

@end
