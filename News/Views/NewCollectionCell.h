//
//  NewCollectionCell.h
//  News
//
//  Created by maruiduan on 14-1-25.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "New.h"

@interface NewCollectionCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *newsImageView;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *subTitle;
@property (nonatomic, strong) IBOutlet UILabel *author;
@property (nonatomic, strong) New *news;

@end
