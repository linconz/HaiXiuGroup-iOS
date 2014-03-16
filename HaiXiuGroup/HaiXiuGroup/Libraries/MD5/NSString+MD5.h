//
//  NSString+MD5.h
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5Extensions)

- (NSString *)md5;
- (NSString *)md5UsingEncoding:(NSStringEncoding)encoding;

@end
