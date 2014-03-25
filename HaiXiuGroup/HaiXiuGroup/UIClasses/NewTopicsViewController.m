//
//  NewTopicsViewController.m
//  HaiXiuGroup
//
//  Created by 王 易平 on 3/22/14.
//  Copyright (c) 2014 zhang. All rights reserved.
//

#import "NewTopicsViewController.h"
#import "Constants+Notification.h"
#import "Constants.h"

#define ImageSize 40
#define AnimationSpeed 40.0f

@interface NewTopicsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    float _btnYOrigin;
    float _btnYWithImage;
    
    NSArray *_btnArray;
    
}

@end

@implementation NewTopicsViewController

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
    
    [self setTitle:@"新的话题"];
    
    UIBarButtonItem *postItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(postTopic)];
    self.navigationItem.rightBarButtonItem = postItem;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(saveEditedData) name:ApplicationWillTerminateNotifacation object:nil];
    
    _imageViewArray = [[NSMutableArray alloc] init];
    
    _btnYOrigin = _imageCaptureButton.frame.origin.y;
    _btnYWithImage = _imageCaptureButton.frame.origin.y + 8 + ImageSize;
    
    _btnArray = [[NSArray alloc] initWithObjects:_imageCaptureButton, _imageSelectButton, _emotionButton, nil];
    
    [self loadNewTopicFromData];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imageSelectButton.hidden = YES;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imageCaptureButton.hidden = YES;
    }
}


- (void)postTopic
{
    
}

-(void)captureImage:(id)sender
{
    if (_newTopic == NULL) {
        _newTopic = [[NewTopic alloc] init];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}


-(void)pickImages:(id)sender
{
    if (_newTopic == NULL) {
        _newTopic = [[NewTopic alloc] init];
    }
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        NSLog(@"%@", [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]);
        imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}


#define kNewTopicDataPath   @"NewTopicData"
#define kNewTopicData       @"NewTopic"

-(void)saveEditedData
{
    if (_newTopic == NULL) {
        _newTopic = [[NewTopic alloc] init];
    }
    
    _newTopic.titleStr = _titleField.text;
    _newTopic.substanceStr = _substanceField.text;
    
    if (_newTopic != NULL) {
        NSDictionary *dict = [_newTopic dictionary];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[[paths objectAtIndex:0] stringByAppendingString:@"/"] stringByAppendingString:kNewTopicDataPath];
        if (![fileManager fileExistsAtPath:path]) {
            NSError *error = nil;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:NULL error:&error];
        }
        
        NSString *filePath = [[path stringByAppendingString:@"/"] stringByAppendingString:kNewTopicData];
        if ([fileManager fileExistsAtPath:filePath]) {
            NSError *error = nil;
            [fileManager removeItemAtPath:filePath error:&error];
        }
        
        [dict writeToFile:filePath atomically:YES];
    }
}

-(void) loadNewTopicFromData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[[[[paths objectAtIndex:0] stringByAppendingString:@"/"] stringByAppendingString:kNewTopicDataPath] stringByAppendingString:@"/"] stringByAppendingString:kNewTopicData];
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        // FIXIT 内存引用
        _newTopic = [NewTopic newTopicWithDictionary:dict];
        [self loadTopic];
    }
}

- (void)loadTopic
{
    if (_newTopic != NULL) {
        _titleField.text = _newTopic.titleStr;
        _substanceField.text = _newTopic.substanceStr;
        
    }
}

- (void) refreshImage
{
    if ([_newTopic.imageArray count] != 0) {
        for (UIButton *btn in _btnArray) {
            float deltaY = _btnYWithImage - btn.frame.origin.y;
            if (deltaY != 0) {
                [UIView animateWithDuration:deltaY/AnimationSpeed delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    CGRect newFrame = btn.frame;
                    newFrame.origin.y += deltaY;
                    btn.frame = newFrame;
                }completion:nil];
            }
        }
        while ([_imageViewArray count] < [_newTopic.imageArray count]) {
            UIImageView *newView;
            if (_imageViewArray.count != 0) {
                UIImageView *leftView = [_imageViewArray lastObject];
                CGRect frame = leftView.frame;
                frame.origin.x += ImageSize + 8;
                newView = [[UIImageView alloc]initWithFrame:frame];
            }
            else {
                newView = [[UIImageView alloc] initWithFrame:CGRectMake(8, _btnYOrigin, ImageSize, ImageSize)];
            }
            newView.image = [_newTopic.imageArray objectAtIndex:_imageViewArray.count];
            
            [_imageViewArray addObject:newView];
            [self.view addSubview:newView];
        }
    }
    else {
        for (UIButton *btn in _btnArray) {
            float deltaY = _btnYOrigin - btn.frame.origin.y;
            if (deltaY != 0) {
                [UIView animateWithDuration:-deltaY/AnimationSpeed delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    CGRect newFrame = btn.frame;
                    newFrame.origin.y += deltaY;
                    btn.frame = newFrame;
                }completion:nil];
            }
        }
    }
    
    while (_imageViewArray.count > _newTopic.imageArray.count) {
        for (int j = 0; j < _imageViewArray.count; j++) {
            UIImageView *imageView = [_imageViewArray objectAtIndex:j];
            if (![_newTopic.imageArray containsObject:imageView.image]) {
                // 左移
                for (int i = [_imageViewArray indexOfObject:imageView] + 1; i < _imageViewArray.count; i++) {
                    UIImageView *rightView = [_imageViewArray objectAtIndex:i];
                    CGRect frame = rightView.frame;
                    frame.origin.x -= ImageSize+8;
                    [UIView animateWithDuration:1.0f animations:^{
                        rightView.frame = frame;
                    }];
                }
                // 删除
                imageView.image = NULL;
                [imageView removeFromSuperview];
                [_imageViewArray removeObject:imageView];
                imageView = nil;
            }
        }
    }
}


#pragma mark - ImagePickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([info objectForKey:UIImagePickerControllerEditedImage] != NULL) {
        [_newTopic.imageArray addObject:[info objectForKey:UIImagePickerControllerEditedImage]];
        [self refreshImage];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
