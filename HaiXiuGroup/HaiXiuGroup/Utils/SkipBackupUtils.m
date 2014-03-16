//
//  SkipBackupUtils.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import <sys/xattr.h>

#import "Constants.h"
#import "SkipBackupUtils.h"

@implementation SkipBackupUtils


+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return NO;
    }
    
    BOOL success = YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.1")) {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        NSError *error = nil;
        success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
        }
    }
    else if(SYSTEM_VERSION_EQUAL_TO(@"5.0.1")) {
        const char* filePath = [path fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        success = (result == 0);
    }
    
    return success;
}

@end
