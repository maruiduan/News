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

@interface ViewController ()

@property (nonatomic, strong) PageDatas *datas;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datas.data count]+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NewTableCellIdentifier];
    cell.textLabel.text = @"sss";
    cell.detailTextLabel.text = @"detailLbale";
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
        New *news = [[New alloc] init];
        news.pickurl = @"asdfasdf";
        NewDetailController *newController = segue.destinationViewController;
        newController.news = news;
    }
}
@end
