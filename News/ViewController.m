//
//  ViewController.m
//  News
//
//  Created by maruiduan on 14-1-18.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import "ViewController.h"
#import "NewTableCell.h"
#import "PageDatas.h"
#import "NewDetailController.h"
#import "StyledPageControl.h"
#import "HTTPClient.h"
#import "NSString+JSON.h"
#import "JSONKit.h"
#import "SVPullToRefresh.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) PageDatas *videoLists;
@property (nonatomic, strong) PageDatas *mainLists;

@property (nonatomic, strong) StyledPageControl *pangeControl;
@end

static NSString *NewTableCellIdentifier = @"NewTableCell";


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    StyledPageControl *pageControl = [[StyledPageControl alloc] init];
    [pageControl setPageControlStyle:PageControlStyleDefault];
    [pageControl setNumberOfPages:10];
    [pageControl setCurrentPage:5];
    [pageControl setGapWidth:5];
    [pageControl setDiameter:9];
//    [pageControl setPageControlStyle:PageControlStyleThumb];
//    [pageControl setThumbImage:[UIImage imageNamed:@"pagecontrol-thumb-normal.png"]];
//    [pageControl setSelectedThumbImage:[UIImage imageNamed:@"pagecontrol-thumb-selected.png"]];
//    pageControl.con
    [self.view addSubview:pageControl];
    
    [self requestMainData];
    [self requestVideoList];
    
    __block ViewController *weak = self;
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        [weak requestVideoList];
//    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weak requestMoreVideoList];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.videoLists.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NewTableCellIdentifier];
    New *news = [self.videoLists.data objectAtIndex:indexPath.row];
    cell.news = news;
    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [NewTableCell heightForCellWithPost:[_posts objectAtIndex:indexPath.row]];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - StoryBoard Callback
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NewDetailController"]) {
        New *news = [(NewTableCell *)sender news];
        NewDetailController *newController = segue.destinationViewController;
        newController.news = news;
    }
}

#pragma mark request

- (void)requestMainData
{
    NSDictionary *parametre = @{@"requestcommand":@"video_list",
                                @"type":@(1)};
    [[HTTPClient sharedClient] postParameters:parametre success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *resultDict = [result JSONDictionary];
        
        self.mainLists = [PageDatas pageDatasWithJSON:resultDict parserClass:[New class]];
        NSLog(@"%@",result);
        
        if ([self.mainLists.data count]) {
            [[self.mainView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperview];
            }];
            
            [self.mainLists.data enumerateObjectsUsingBlock:^(New *news, NSUInteger idx, BOOL *stop) {
                UIImageView *imageView = UIImageView.new;
                [imageView setImageWithURL:[NSURL URLWithString:news.pickurl]];
                CGRect rect = self.mainView.frame;
                rect.origin.x = CGRectGetWidth(self.mainView.frame) * idx;
                rect.origin.y = 0;
                imageView.frame = rect;
                self.mainView.contentSize = CGSizeMake(CGRectGetWidth(self.mainView.frame)*(idx+1), CGRectGetHeight(self.mainView.frame));
                [self.mainView addSubview:imageView];
            }];

        }        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestVideoList
{
    NSDictionary *parametre = @{@"requestcommand":@"video_list",
                                @"pagesize":@"30",
                                @"pagenumber":@(1),
                                @"type":@(1)};
    [[HTTPClient sharedClient] postParameters:parametre success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *resultDict = [result JSONDictionary];
        
        self.videoLists = [PageDatas pageDatasWithJSON:resultDict parserClass:[New class]];
        NSLog(@"%@",result);
        
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
        self.tableView.infiniteScrollingView.enabled = self.videoLists.more;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)requestMoreVideoList
{
    int page = 1;
    if (self.videoLists.more) {
        page = self.videoLists.page + 1;
    }else{
        return;
    }
    NSDictionary *parametre = @{@"requestcommand":@"video_list",
                                @"pagesize":@"30",
                                @"pagenumber":@(page),
                                @"type":@(1)};
    [[HTTPClient sharedClient] postParameters:parametre success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *resultDict = [result JSONDictionary];
        
        self.videoLists = [PageDatas pageDatasWithJSON:resultDict parserClass:[New class]];
        NSLog(@"%@",result);
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
        self.tableView.infiniteScrollingView.enabled = self.videoLists.more;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.infiniteScrollingView stopAnimating];

    }];
}

#pragma mark -UIScrollView

#pragma mark -UITextField

@end
