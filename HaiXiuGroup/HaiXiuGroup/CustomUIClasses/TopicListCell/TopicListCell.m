//
//  TopicListCell.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "TopicListCell.h"
#import "Topic.h"
#import "User.h"
#import "NSStringExtra.h"
#import "ImageCacheEngine.h"

#define TITLE_Y 41
#define TITLE_WIDTH 243

@implementation TopicListCell

@synthesize topic = _topic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"TopicListCell" owner:self options:nil];
        [self.contentView addSubview:_authorLabel];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_createdLabel];
        [self.contentView addSubview:_topicImageButton];
        [self.contentView addSubview:_avatarButton];
        [_topicImageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopic:(Topic *) topic
{
    [_authorLabel setText:topic.author.name];
    [_titleLabel setText:topic.title];
    [_createdLabel setText:[self intervalSinceNow:topic.created]];
    CGSize titleSize = [topic.title sizeWithFont:[UIFont systemFontOfSize:15]
                               constrainedToSize:CGSizeMake(TITLE_WIDTH, INT16_MAX)
                                   lineBreakMode:NSLineBreakByCharWrapping];
    [_titleLabel setFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, titleSize.width, titleSize.height)];
    
    if ([topic.photos count] > 0) {
        CGRect topicImageViewFrame = _topicImageButton.frame;
        topicImageViewFrame.origin.y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 8;
        [_topicImageButton setFrame:topicImageViewFrame];
        
        CGRect createdTimeLabelFrame = _createdLabel.frame;
        createdTimeLabelFrame.origin.y = _topicImageButton.frame.origin.y + _topicImageButton.frame.size.height + 8;
        [_createdLabel setFrame:createdTimeLabelFrame];
    } else {
        CGRect createdTimeLabelFrame = _createdLabel.frame;
        createdTimeLabelFrame.origin.y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 8;
        [_createdLabel setFrame:createdTimeLabelFrame];
    }

    NSString *avatarPath = [[ImageCacheEngine sharedInstance] getImagePathByUrl:topic.author.avatar];
    if (avatarPath) {
        [_avatarButton setBackgroundImage:[UIImage imageWithContentsOfFile:avatarPath]
                                 forState:UIControlStateNormal];
    } else {
        [_avatarButton setBackgroundImage:[UIImage imageWithContentsOfFile:@"block"]
                                 forState:UIControlStateNormal];
    }
    
    if ([topic.photos count] > 0) {
        NSString *photoFirstUrl = [topic.photos objectAtIndex:0];
        if (photoFirstUrl && [photoFirstUrl length] > 0) {
            NSString *imagePath = [[ImageCacheEngine sharedInstance] getImagePathByUrl:photoFirstUrl];
            if (imagePath) {
                [_topicImageButton setImage:[UIImage imageWithContentsOfFile:imagePath]
                                             forState:UIControlStateNormal];
            } else {
                [_topicImageButton setImage:[UIImage imageWithContentsOfFile:@"block"]
                                   forState:UIControlStateNormal];
            }
        }
    }
}

- (NSString *)intervalSinceNow: (NSDate *) d
{
    NSDateFormatter *outPutDateStringFormatter = [[NSDateFormatter alloc] init];
    [outPutDateStringFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString = @"";
    
    NSTimeInterval cha = now - late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
    }
    if ([timeString isEqualToString:@""]) {
        timeString = [outPutDateStringFormatter stringFromDate:d];
    }
    return timeString;
}

+(float) getCellHeight:(Topic *) topic
{
    float returnHeight = 0;
    NSString *title = topic.title;
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:15]
                         constrainedToSize:CGSizeMake(TITLE_WIDTH, INT16_MAX)
                             lineBreakMode:NSLineBreakByCharWrapping];
    
    if ([topic.photos count] > 0) {
        returnHeight = titleSize.height + TITLE_Y + 8 + 100 + 8 + 18 + 8;
    } else {
        returnHeight = titleSize.height + TITLE_Y + 8 + 18 + 8;
    }
    return returnHeight;
}

#pragma mark - 按钮

- (IBAction)avatarButtonClick:(id)sender
{
    
}

- (IBAction)topicImageButtonClick:(id)sender
{
    
}
@end
