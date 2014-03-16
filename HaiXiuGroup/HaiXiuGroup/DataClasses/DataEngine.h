//
//  DataEngine.h
//  HaiXiuGroup
//
//  Created by zhang on 14-3-14.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface DataEngine : NSObject<ASIHTTPRequestDelegate>
{
    NSMutableArray      *_topics;
}

@property (nonatomic, retain) NSMutableArray *topics;

+ (DataEngine *)sharedDataEngine;
- (DataEngine *)init;

- (void)getGroupTopics:(NSNumber *) startPage
              pageSize:(NSNumber *) pageSize
                source:(NSString *) source;
@end
