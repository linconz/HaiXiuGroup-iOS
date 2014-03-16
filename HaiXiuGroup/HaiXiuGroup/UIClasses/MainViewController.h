//
//  MainViewController.h
//  HaiXiuGroup
//
//  Created by zhang on 14-3-14.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    NSString            *_controllerId;
    IBOutlet UIButton   *_testButton;
}
- (IBAction)testButtonClick:(id)sender;
@end
