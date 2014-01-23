//
//  NewTableCell.h
//  News
//
//  Created by maruiduan on 14-1-18.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "New.h"
@interface NewTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *newsImageView;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *subTitle;
@property (nonatomic, strong) New *news;

@end
