//
//  NSStringExtra.h
//  ThreeHundred
//
//  Created by 郭雪 on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringExtra)

- (NSString*)stringByTrimmingBoth;
- (NSString*)stringByTrimmingLeadingWhitespace;
// 格式化为货币
- (NSString*)stringToMoneyFormat:(NSString *)str;
// 所有字符替换为＊
- (NSString*)stringAllToStar;
//using NSLineBreakByWordWrapping
- (CGSize)newSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
