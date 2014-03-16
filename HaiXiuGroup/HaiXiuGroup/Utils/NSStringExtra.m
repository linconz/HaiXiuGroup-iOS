//
//  NSStringExtra.m
//  ThreeHundred
//
//  Created by 郭雪 on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSStringExtra.h"

@implementation NSString (NSStringExtra)

- (NSString*)stringByTrimmingBoth {
    NSString *trimmed = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmed;
}

- (NSString*)stringByTrimmingLeadingWhitespace {
    NSInteger i = 0;
    
    while (i < self.length && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    if (i < self.length) {
        return [self substringFromIndex:i];
    } else {
        return @"";
    }
}

- (NSString*)stringToMoneyFormat:(NSString *)str
{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:[str intValue]]];
    
    return numberString;
}

- (NSString*)stringAllToStar
{
    NSMutableString *starString = [NSMutableString stringWithCapacity:self.length];
    for (int i = 0; i < self.length; i++) {
        [starString appendString:@"*"];
    }
    return starString;
}

- (CGSize)newSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize newSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        CGRect expectedFrame = [self boundingRectWithSize:size
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           font, NSFontAttributeName, nil]
                                                  context:nil];
        newSize = expectedFrame.size;
        newSize.height = ceil(newSize.height); //iOS7 is not rounding up to the nearest whole number
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        newSize = [self sizeWithFont:font
                   constrainedToSize:size
                       lineBreakMode:NSLineBreakByWordWrapping];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    return newSize;
}

@end
