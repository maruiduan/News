//
//  ViewController.h
//  News
//
//  Created by maruiduan on 14-1-18.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) IBOutlet UIScrollView *mainView;
@property (nonatomic ,strong) IBOutlet UIDatePicker *timeView;

@property (nonatomic, strong) IBOutlet UITextField *searchView;
@property (nonatomic, strong) IBOutlet UIButton *dateButton;

@end
