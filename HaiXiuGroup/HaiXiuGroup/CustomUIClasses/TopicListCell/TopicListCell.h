//
//  TopicListCell.h
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Topic;

@interface TopicListCell : UITableViewCell
{
    IBOutlet UILabel            *_authorLabel;
    IBOutlet UILabel            *_titleLabel;
    IBOutlet UILabel            *_createdLabel;
    IBOutlet UIButton           *_topicImageButton;
    IBOutlet UIButton           *_avatarButton;
    
    Topic                       *_topic;
}
@property (nonatomic, retain) Topic *topic;

- (IBAction)avatarButtonClick:(id)sender;
- (IBAction)topicImageButtonClick:(id)sender;

+(float) getCellHeight:(Topic *) topic;

@end
