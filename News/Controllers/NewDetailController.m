//
//  NewDetailController.m
//  News
//
//  Created by maruiduan on 14-1-19.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import "NewDetailController.h"
#import "VideoController.h"
#import "UIButton+WebCache.h"

@interface NewDetailController ()

@end

@implementation NewDetailController

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
    [self setNews:_news];
    _newsImageView.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setNews:(New *)news
{
    _news = news;
    self.newsTitle.text = news.title;
    self.newsSubTitle.text = [NSString stringWithFormat:@"%@ %@",news.author, news.addtime];
    self.newsDetail.text = news.contents;
    
    __block NewDetailController *weak = self;
    [self.newsImageView setImageWithURL:[NSURL URLWithString:news.pickurl] success:^(UIImage *image, BOOL cached) {
        weak.newsImageView.imageView.image = image;
        [weak.newsImageView setBackgroundImage:nil forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"VideoController"]) {
        VideoController *videoController = segue.destinationViewController;
        videoController.url = self.news.videourl;
    }
}

@end
