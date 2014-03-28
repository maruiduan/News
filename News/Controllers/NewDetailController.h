//
//  NewDetailController.h
//  News
//
//  Created by maruiduan on 14-1-19.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "New.h"

@interface NewDetailController : BaseViewController

@property (nonatomic, strong) New *news;
@property (nonatomic, strong) IBOutlet UILabel *newsTitle;
@property (nonatomic, strong) IBOutlet UILabel *newsSubTitle;
@property (nonatomic, strong) IBOutlet UIWebView *newsDetail;
@property (nonatomic, strong) IBOutlet UIButton *newsImageView;


@end
