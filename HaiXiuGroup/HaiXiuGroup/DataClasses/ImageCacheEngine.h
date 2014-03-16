//
//  ImageCacheEngine.h
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCacheEngine : NSObject {
    NSString            *_imageRootDir;
	NSFileManager       *_fileManager;
}

@property (nonatomic, readonly) NSString *imageRootDir;

+ (ImageCacheEngine *)sharedInstance;
- (ImageCacheEngine *)init;

// get image from disk.
- (NSString *)getImagePathByUrl:(NSString *)url;

// store image to local storage.
- (NSString *)setImagePath:(NSData *)data 
                    forUrl:(NSString *)url;


@end
