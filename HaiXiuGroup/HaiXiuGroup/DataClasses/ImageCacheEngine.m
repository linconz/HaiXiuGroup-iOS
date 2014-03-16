//
//  ImageCacheEngine.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "Constants.h"
#import "SkipBackupUtils.h"

#import "ImageCacheEngine.h"
#import "NSString+MD5.h"
#import "DataEngine.h"

#define kImageStorePath      @"images"

static ImageCacheEngine *_imageEngine = nil;

@interface ImageCacheEngine (Private)

- (void)createDirectory;

- (NSString *)storeImageToLocal:(NSData *)data filePath:(NSString *)filePath;

- (void)deleteImage:(NSString *)path;

@end

@implementation ImageCacheEngine
@synthesize imageRootDir = _imageRootDir;

+ (ImageCacheEngine *)sharedInstance
{
	@synchronized(_imageEngine) {
		if (!_imageEngine) {
			_imageEngine = [[ImageCacheEngine alloc] init];
		}
	}
	return _imageEngine;	
}

- (ImageCacheEngine *)init
{
    self = [super init];
	if (self) {        
		_fileManager = [NSFileManager defaultManager];
        
        if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"5.0")) {
            NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            _imageRootDir = [[[cachesPaths objectAtIndex:0] stringByAppendingString:@"/"] stringByAppendingPathComponent:kImageStorePath];
        } else {
            NSArray *supportPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
            _imageRootDir = [[[supportPaths objectAtIndex:0] stringByAppendingString:@"/"] stringByAppendingPathComponent:kImageStorePath];
        }
        NSLog(@"_imageRootDir:%@", _imageRootDir);
        
        [self createDirectory];
        [SkipBackupUtils addSkipBackupAttributeToItemAtPath:_imageRootDir];
	}
	return self;
}

#pragma mark - 私有API
- (void)createDirectory
{
	if (![_fileManager fileExistsAtPath:_imageRootDir]) {
        NSError *error = nil;
		[_fileManager createDirectoryAtPath:_imageRootDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

- (NSString *)storeImageToLocal:(NSData *)data filePath:(NSString *)filePath
{
    if ((!data) || (!filePath)) {
        return nil;
    }
    
    [self deleteImage:filePath];
    if ([data writeToFile:filePath options:NSAtomicWrite error:nil]) {
        return filePath;
    }
    return nil;
}

- (void)deleteImage:(NSString *)path
{
    if ([_fileManager fileExistsAtPath:path] == YES) {
		[_fileManager removeItemAtPath:path error:nil];
	}
}

#pragma mark - 公开接口

- (NSString *)getImagePathByUrl:(NSString *)url 
{
    NSString *imageFile = nil;
    imageFile = [NSString stringWithFormat:@"%@/%@", _imageRootDir, [url md5]];
    
    if ([_fileManager fileExistsAtPath:imageFile]) {
        return imageFile;
    } else {
        return nil;
    }
}

- (NSString *)setImagePath:(NSData *)data 
                    forUrl:(NSString *)url 
{
    if ((!url) || (!data)) {
        return nil;
    }
    NSString *imageFile = nil;
    imageFile = [NSString stringWithFormat:@"%@/%@", _imageRootDir, [url md5]];
    return [self storeImageToLocal:data filePath:imageFile];
}

@end
