//
//  TopicListViewController.h
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"

@interface TopicListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, LoadMoreTableFooterDelegate>
{
    NSString                        *_controllerId;
    
    // 下拉
    EGORefreshTableHeaderView       *_refreshHeaderView;
    BOOL                            _reloading;
    
    // 上拉
    LoadMoreTableFooterView         *_loadMoreFooterView;
    BOOL                            _loadingMore;
    BOOL                            _loadMoreShowing;
    BOOL                            _isNeedRefresh;
    
    int                             _currentPage;

    IBOutlet UITableView            *_tableView;
}

@end
