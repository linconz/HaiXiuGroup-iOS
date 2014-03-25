//
//  TopicListViewController.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "TopicListViewController.h"
#import "DataEngine.h"
#import "Constants+APIRequest.h"
#import "Constants+ErrorCodeDef.h"
#import "Constants+RetrunParamDef.h"
#import "AppDelegate.h"
#import "User.h"
#import "Topic.h"
#import "ImageCacheEngine.h"

#import "TopicDetailViewController.h"
#import "SVWebViewController.h"

#import "TopicListCell.h"

#import "NewTopicsViewController.h"

#define PAGESIZE 20

@interface TopicListViewController (notification)

- (void)responseGetTopics:(NSNotification *) notification;
- (void)responseDownloadImage:(NSNotification *) notification;

@end

@implementation TopicListViewController

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
    self.navigationItem.title = NSLocalizedString(@"主题列表", @"");

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responseGetTopics:)
                                                 name:REQUEST_HAIXIUZU_TOPICS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responseDownloadImage:)
                                                 name:REQUEST_DOWNLOADFILE_NOTIFICATION_NAME
                                               object:nil];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSLog(@"%f", _tableView.bounds.size.height);
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height)];
		view.delegate = self;
		[_tableView addSubview:view];
		_refreshHeaderView = view;
	}
	[_refreshHeaderView refreshLastUpdatedDate];
    
    if (_loadMoreFooterView == nil) {
		LoadMoreTableFooterView *view = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, _tableView.contentSize.height, _tableView.frame.size.width, _tableView.bounds.size.height)];
		view.delegate = self;
		[_tableView addSubview:view];
		_loadMoreFooterView = view;
        _loadMoreShowing = NO;
	}
    [self requestGetItems];
    
    
    // -----------wypEdited-----------
    UIBarButtonItem *newTopicItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(loadNewTopicViewController)];
    self.navigationItem.rightBarButtonItem = newTopicItem;
}

- (void)loadNewTopicViewController
{
    NewTopicsViewController *newTopicVC = [[NewTopicsViewController alloc] initWithNibName:@"NewTopicsViewController" bundle:nil];
    [self.navigationController pushViewController:newTopicVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    _refreshHeaderView = nil;
    _loadMoreFooterView = nil;
    [super viewDidUnload];
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DataEngine sharedDataEngine].topics count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic *topic = [[DataEngine sharedDataEngine].topics objectAtIndex:indexPath.row];
    return [TopicListCell getCellHeight:topic];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TopicListCell *cell = (TopicListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TopicListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Topic *topic = [[DataEngine sharedDataEngine].topics objectAtIndex:indexPath.row];
//    [cell.textLabel setText:topic.title];
//    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell setTopic:topic];
    NSString *imagePath = [[ImageCacheEngine sharedInstance] getImagePathByUrl:topic.author.avatar];
    if (!imagePath) {
        //下载图片
        [[DataEngine sharedDataEngine] downloadFileByUrl:topic.author.avatar
                                                    from:_controllerId];
    }
    // 图片
    if ([topic.photos count] > 0) {
        NSString *photoFirstUrl = [topic.photos objectAtIndex:0];
        if (photoFirstUrl && [photoFirstUrl length] > 0) {
            NSString *imagePath = [[ImageCacheEngine sharedInstance] getImagePathByUrl:photoFirstUrl];
            if (!imagePath) {
                //下载图片
                [[DataEngine sharedDataEngine] downloadFileByUrl:photoFirstUrl
                                                            from:_controllerId];
            }
        }
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Topic *topic = [[DataEngine sharedDataEngine].topics objectAtIndex:indexPath.row];
    SVWebViewController *web = [[SVWebViewController alloc] initWithAddress:topic.alt];
    [self.navigationController pushViewController:web animated:YES];
    
//    TopicDetailViewController *topicDetail = [[TopicDetailViewController alloc] initWithNibName:@"TopicDetailViewController" bundle:nil];
}

#pragma mark - 通知

- (void)responseGetTopics:(NSNotification *) notification
{
    NSDictionary *dictionary = (NSDictionary *)[notification userInfo];
    if (![[dictionary objectForKey:REQUEST_SOURCE_KEY] isEqualToString:_controllerId]) {
        return;
    }
    NSNumber *returnCode = [dictionary objectForKey:RETURN_CODE];
    if (returnCode && [returnCode isKindOfClass:[NSNumber class]] && [returnCode intValue] == NO_ERROR) {
        if (_reloading) {
            [self doneLoadingTableViewData];
        }
        if (_loadingMore) {
            [self doneLoadingMoreTableViewData];
        }
        
        // 更新界面
        NSMutableArray *array = [DataEngine sharedDataEngine].topics;
        NSLog(@"array all count:%d", [array count]);
        [_tableView reloadData];
        NSNumber *itemsCount = [dictionary objectForKey:@"count"];
        if (itemsCount && [itemsCount isKindOfClass:[NSNumber class]] && [itemsCount intValue] > 0) {
            if ([itemsCount intValue] != PAGESIZE) {
                _loadMoreShowing = NO;
            } else {
                _loadMoreShowing = YES;
            }
        } else {
            _loadMoreShowing = NO;
        }
        if (!_loadMoreShowing) {
            _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        }
        [_tableView reloadData];
    } else {
        // 错误处理
    }
}

- (void)responseDownloadImage:(NSNotification *) notification
{
    NSDictionary *dictionary = (NSDictionary *)[notification userInfo];
    if (![[dictionary objectForKey:REQUEST_SOURCE_KEY] isEqualToString:_controllerId]) {
        return;
    }
    NSNumber *returnCode = [dictionary objectForKey:RETURN_CODE];
    if (returnCode && [returnCode isKindOfClass:[NSNumber class]] && [returnCode intValue] == NO_ERROR) {
        
        NSString *imagePath = [dictionary objectForKey:TOUI_PARAM_DOWNLOADFILE_FILEPATH];
        if (imagePath) {
            [self loadImagesForOnscreenRows];
        }
    } else {
        // 错误处理
    }
}

- (void)requestGetItems
{
    [[DataEngine sharedDataEngine] getGroupTopics:[NSNumber numberWithInt:_currentPage * PAGESIZE]
                                         pageSize:[NSNumber numberWithInt:PAGESIZE]
                                           source:_controllerId];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	_reloading = YES;
    _currentPage = 0;
	[self requestGetItems];
}

- (void)doneLoadingTableViewData
{
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    _reloading = NO;
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date];
}

#pragma mark -
#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view
{
	[self loadMoreTableViewDataSource];
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view
{
	return _loadingMore;
}

- (void)loadMoreTableViewDataSource
{
    _loadingMore = YES;
    _currentPage ++;
    [self requestGetItems];
}

- (void)doneLoadingMoreTableViewData
{
    _loadingMore = NO;
    [_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:_tableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if (_loadMoreShowing) {
        [_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// 停止拖拽时执行
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    if (_loadMoreShowing) {
        [_loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
    }
    if (!decelerate) {
        // 停止拖拽时加载当前显示的图片
        [self loadImagesForOnscreenRows];
    }
}

// 减速停止时执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDecelerating:scrollView];
    // 停止滑动时加载当前显示的图片
    [self loadImagesForOnscreenRows];
}

- (void)loadImagesForOnscreenRows
{
    // 载入当前屏幕图片
    NSArray *topicsArray = [DataEngine sharedDataEngine].topics;
    if ([topicsArray count] > 0) {
        NSArray *visiblePaths = [_tableView indexPathsForVisibleRows];
        BOOL needReloadData = NO;
        for (NSIndexPath *indexPath in visiblePaths) {
            if (indexPath.row < [topicsArray count]) {
                Topic *topic = [[DataEngine sharedDataEngine].topics objectAtIndex:indexPath.row];
                NSString *imagePath = [[ImageCacheEngine sharedInstance] getImagePathByUrl:topic.author.avatar];
                if (imagePath) {
                    needReloadData = YES;
                }
                if ([topic.photos count] > 0) {
                    NSString *photoFirstUrl = [topic.photos objectAtIndex:0];
                    NSString *imagePath = [[ImageCacheEngine sharedInstance] getImagePathByUrl:photoFirstUrl];
                    if (imagePath) {
                        needReloadData = YES;
                    }
                }
            }
        }
        if (needReloadData) {
            if (![_tableView isDecelerating] && ![_tableView isDragging]) {
                [_tableView reloadData];
            }
        }
    }
}
@end
