//
//  NewTopicsViewController.h
//  HaiXiuGroup
//
//  Created by 王 易平 on 3/22/14.
//  Copyright (c) 2014 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTopic.h"

@interface NewTopicsViewController : UIViewController

{
    IBOutlet UITextField *_titleField;
    IBOutlet UITextView *_substanceField;
    IBOutlet UIButton *_imageCaptureButton;
    IBOutlet UIButton *_imageSelectButton;
    IBOutlet UIButton *_emotionButton;
//    IBOutlet UIButton *_keyboardButton;
    
    NewTopic *_newTopic;
    
    NSMutableArray *_imageViewArray;
}

-(void) saveEditedData;
-(IBAction)pickImages:(id)sender;
-(IBAction)captureImage:(id)sender;

@end
