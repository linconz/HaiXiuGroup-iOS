//
//  ErrorCodeUtils.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "ErrorCodeUtils.h"

@implementation ErrorCodeUtils

+ (NSString*)errorDetailFromErrorCode:(int)errorCode
{
    NSString* errorDetail = nil;
    switch (errorCode) {
        case -1:
            errorDetail = NSLocalizedString(@"连接服务器时发生错误", @"");
            break;
        case -2:
            errorDetail = NSLocalizedString(@"豆瓣服务器返回数据有误", @"");
            break;
        default:
            errorDetail = [NSString stringWithFormat:NSLocalizedString(@"未知错误,错误码%d", @""), errorCode];
            break;
    }
    return errorDetail;
}

@end
