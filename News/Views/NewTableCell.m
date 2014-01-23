//
//  NewTableCell.m
//  News
//
//  Created by maruiduan on 14-1-18.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import "NewTableCell.h"
#import "UIImageView+WebCache.h"

@implementation NewTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
