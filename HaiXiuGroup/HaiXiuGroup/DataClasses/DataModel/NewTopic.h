//
//  NewTopic.h
//  HaiXiuGroup
//
//  Created by 王 易平 on 3/22/14.
//  Copyright (c) 2014 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewTopic : NSObject

@property (nonatomic, retain) NSString *titleStr;
@property (nonatomic, retain) NSString *substanceStr;
@property (nonatomic, retain) NSMutableArray *imageArray;


-(NSDictionary *)dictionary;

+(NewTopic *)newTopicWithDictionary:(NSDictionary *)dict;

@end
