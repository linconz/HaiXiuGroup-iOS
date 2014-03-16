//
//  User.h
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>
{
    // 用户id
    NSString            *_userId;
    // 链接
    NSString            *_alt;
    // 用户昵称
    NSString            *_name;
    // 头像地址
    NSString            *_avatar;
    // 是否注销
    BOOL                _isSuicide;
}
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *alt;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *avatar;
@property (assign) BOOL isSuicide;

@end
