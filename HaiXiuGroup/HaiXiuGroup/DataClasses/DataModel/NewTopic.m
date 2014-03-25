//
//  NewTopic.m
//  HaiXiuGroup
//
//  Created by 王 易平 on 3/22/14.
//  Copyright (c) 2014 zhang. All rights reserved.
//

#import "NewTopic.h"

@implementation NewTopic

@synthesize imageArray;
@synthesize substanceStr;
@synthesize titleStr;

-(id)init
{
    if (self = [super init]) {
        imageArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#define K_SUBSTANCE     @"K_newTopic_substance"
#define K_TITLE         @"K_newTopic_title"
#define K_IMAGEARRAY    @"K_newTopic_imageArray"

-(NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:substanceStr forKey:K_SUBSTANCE];
    [dict setObject:titleStr forKey:K_TITLE];
    [dict setObject:imageArray forKey:K_IMAGEARRAY];
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

+(NewTopic *)newTopicWithDictionary:(NSDictionary *)dict
{
    if (dict == NULL) {
        return NULL;
    }
    
    NewTopic *newTopic = [[NewTopic alloc] init];
    newTopic.substanceStr = [dict objectForKey:K_SUBSTANCE];
    newTopic.titleStr = [dict objectForKey:K_TITLE];
    newTopic.imageArray = [[NSMutableArray alloc] initWithArray:[dict objectForKey:[dict objectForKey:K_IMAGEARRAY]]];
    return newTopic;
}



@end
