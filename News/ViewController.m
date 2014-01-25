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
#import "UIButton+WebCache.h"

@interface ViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) PageDatas *videoLists;
@property (nonatomic, strong) PageDatas *mainLists;

@property (nonatomic, strong) StyledPageControl *pangeControl;
@property (nonatomic, strong) UIActionSheet *pickerViewPopup;

@property (nonatomic) BOOL isSearch;

@end

static NSString *NewTableCellIdentifier = @"NewTableCell";


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isSearch = YES;
    
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

- (void)pushDetailController:(UIButton *)button
{
//    NewDetailController *newController = NewDetailController.new;
//    newController.news = self.mainLists.data[button.tag];
//    [self.navigationController pushViewController:newController animated:YES];
    [self performSegueWithIdentifier:@"NewDetailController" sender:self.mainLists.data[button.tag]];
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
        if ([sender isKindOfClass:[New class]]) {
            New *news = sender;
            NewDetailController *newController = segue.destinationViewController;
            newController.news = news;
        }else{
            New *news = [(NewTableCell *)sender news];
            NewDetailController *newController = segue.destinationViewController;
            newController.news = news;
        }
    }else if ([segue.identifier isEqualToString:@"DatePickerController"]){

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
                UIButton *button = UIButton.new;
                [button setImageWithURL:[NSURL URLWithString:news.pickurl]];
                CGRect rect = self.mainView.frame;
                rect.origin.x = CGRectGetWidth(self.mainView.frame) * idx;
                rect.origin.y = 0;
                button.frame = rect;
                self.mainView.contentSize = CGSizeMake(CGRectGetWidth(self.mainView.frame)*(idx+1), CGRectGetHeight(self.mainView.frame));
                [self.mainView addSubview:button];
                button.tag = idx;
                [button addTarget:self action:@selector(pushDetailController:) forControlEvents:UIControlEventTouchUpInside];
            }];

        }        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestVideoList
{
    _isSearch = NO;
    NSDictionary *parametre = @{@"requestcommand":@"video_list",
                                @"pagesize":@"30",
                                @"pagenumber":@(0)};
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
                                @"pagenumber":@(page)};
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

- (void)requestSearchTitle:(NSString *)title date:(NSString *)date page:(int)page
{
    _isSearch = YES;
    NSString *da = date;
    if ([date isEqualToString:@"选择时间"]) {
        da = @"";
    }
    
    NSDictionary *parametre = @{@"requestcommand":@"video_list",
                                @"title":title,
                                @"times":da,
                                @"pagesize":@"30",
                                @"pagenumber":@(page)};
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!textField.text.length) {
    }else{
        [self requestSearchTitle:textField.text date:self.dateButton.titleLabel.text page:1];
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -Action
- (IBAction)select:(id)sender
{
    _pickerViewPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    pickerView.datePickerMode = UIDatePickerModeDate;
    pickerView.hidden = NO;
    [pickerView setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    pickerView.date = [NSDate date];
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    [barItems addObject:cancelBtn];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    [barItems addObject:doneBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [_pickerViewPopup addSubview:pickerToolbar];
    [_pickerViewPopup addSubview:pickerView];
    [_pickerViewPopup showInView:self.view];
    [_pickerViewPopup setBounds:CGRectMake(0,0,320, 464)];
}

- (void)doneButtonPressed{
    [_pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[formatter stringFromDate:date];
    [self.dateButton setTitle:str forState:UIControlStateNormal];
}


- (void)cancelButtonPressed{
    [_pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
}
@end
