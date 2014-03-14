//
//  MainViewController.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-14.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "MainViewController.h"
#import "DataEngine.h"

@interface MainViewController ()

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)testButtonClick:(id)sender
{
    [[DataEngine sharedDataEngine] getGroupTopics:[NSNumber numberWithInt:0]
                                         pageSize:[NSNumber numberWithInt:20]
                                           source:[NSString stringWithFormat:@"%@", self]];
}

@end
