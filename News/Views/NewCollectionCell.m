//
//  NewCollectionCell.m
//  News
//
//  Created by maruiduan on 14-1-25.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import "NewCollectionCell.h"
#import "UIImageView+WebCache.h"

@implementation NewCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setNews:(New *)news
{
    _news = news;
    self.title.text = news.title;
    self.subTitle.text = news.synopsis;
    self.author.text = [NSString stringWithFormat:@"%@ %@",news.author, news.addtime];
    
    [self.newsImageView setImageWithURL:[NSURL URLWithString:news.pickurl]];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
