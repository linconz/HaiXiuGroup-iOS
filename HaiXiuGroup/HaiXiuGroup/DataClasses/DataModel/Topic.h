//
//  Topic.h
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Topic : NSObject <NSCoding>
{
    // 主题id
    NSString                *_topicId;
    // 主题链接
    NSString                *_alt;
    // 标题
    NSString                *_title;
    // 内容
    NSString                *_content;
    // 喜欢
    NSNumber                *_likeCount;
    // 回复数量
    NSNumber                *_commentsCount;
    // 作者
    User                    *_author;
    // 主题创建时间
    NSDate                  *_created;
    // 最后更新时间
    NSDate                  *_updated;
    // 图片
    NSMutableArray          *_photos;
}
@property (nonatomic, retain) NSString *topicId;
@property (nonatomic, retain) NSString *alt;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSNumber *likeCount;
@property (nonatomic, retain) NSNumber *commentsCount;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) NSDate *created;
@property (nonatomic, retain) NSDate *updated;
@property (nonatomic, retain) NSMutableArray *photos;

@end
