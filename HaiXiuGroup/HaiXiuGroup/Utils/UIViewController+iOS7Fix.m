//
//  UIViewController+iOS7Fix.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "UIViewController+iOS7Fix.h"

@implementation UIViewController (iOS7Fix)

- (void)viewDidLoad
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
}

@end
