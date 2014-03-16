//
//  MainViewController.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-14.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "MainViewController.h"
#import "DataEngine.h"
#import "Constants+APIRequest.h"
#import "Constants+ErrorCodeDef.h"

@interface MainViewController (notification)

- (void)responseGetTopics:(NSNotification *)notification;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _controllerId = [NSString stringWithFormat:@"%@", self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responseGetTopics:)
                                                 name:REQUEST_HAIXIUZU_TOPICS
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)testButtonClick:(id)sender
{
    [[DataEngine sharedDataEngine] getGroupTopics:[NSNumber numberWithInt:0]
                                         pageSize:[NSNumber numberWithInt:20]
                                           source:_controllerId];
}

#pragma mark 通知

- (void)responseGetTopics:(NSNotification *)notification
{
    NSDictionary *dictionary = (NSDictionary *)[notification userInfo];
    if (![[dictionary objectForKey:REQUEST_SOURCE_KEY] isEqualToString:_controllerId]) {
        return;
    }
    NSNumber *returnCode = [dictionary objectForKey:RETURN_CODE];
    if (returnCode && [returnCode isKindOfClass:[NSNumber class]] && [returnCode intValue] == NO_ERROR) {
        // 更新界面
        NSMutableArray *array = [DataEngine sharedDataEngine].topics;
        NSLog(@"array count:%d", [array count]);
    } else {
        // 错误处理
    }
}

@end
