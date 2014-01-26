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
#import "SVPullToRefresh.h"
#import "UIButton+WebCache.h"
#import "NewCollectionCell.h"

@interface ViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) PageDatas *videoLists;
@property (nonatomic, strong) PageDatas *mainLists;

@property (nonatomic, strong) StyledPageControl *pageControl;
@property (nonatomic, strong) UIActionSheet *pickerViewPopup;
@property (nonatomic, strong) UIDatePicker *pickerView;
@property (nonatomic, strong) UIPopoverController *popOverController;

@property (nonatomic) BOOL isSearch;

@end

static NSString *NewTableCellIdentifier = @"NewTableCell";
static NSString *NewCollectionCellIdentifier = @"NewCollectionCell";


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    _isSearch = NO;
    
    _pageControl = [[StyledPageControl alloc] init];
    [_pageControl setPageControlStyle:PageControlStyleDefault];
    [_pageControl setNumberOfPages:4];
    [_pageControl setCurrentPage:1];
    [_pageControl setGapWidth:5];
    [_pageControl setDiameter:9];
//    [pageControl setPageControlStyle:PageControlStyleThumb];
//    [pageControl setThumbImage:[UIImage imageNamed:@"pagecontrol-thumb-normal.png"]];
//    [pageControl setSelectedThumbImage:[UIImage imageNamed:@"pagecontrol-thumb-selected.png"]];
//    pageControl.con
    [self.view addSubview:_pageControl];
    
    CGFloat height = 20;
    CGFloat width = 80;
    
    
    CGFloat delta = 0;
    if (IS_IPAD) {
        if (!iS_IOS7) {
            delta = 20;
        }
    }
    
    CGRect frame = CGRectMake(CGRectGetMaxX(self.mainView.frame)-width, CGRectGetMaxY(self.mainView.frame)-height-delta, width, height);
    _pageControl.frame = frame;
    _pageControl.hidden = YES;
    
    
    [self requestMainData];
    [self requestVideoList];
    
//    __block ViewController *weak = self;
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        [weak requestVideoList];
//    }];
    
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        [weak requestMoreVideoList];
//    }];
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
            
            if (self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
                self.pageControl.hidden = NO;
            }
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

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.collectionView reloadData];

        }else{
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
            self.tableView.infiniteScrollingView.enabled = self.videoLists.more;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)requestMoreVideoList
{
    NSInteger page = 1;
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
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.collectionView reloadData];
            
        }else{
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
            self.tableView.infiniteScrollingView.enabled = self.videoLists.more;
        }
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
    
    NSDictionary *parametre = [NSMutableDictionary dictionaryWithDictionary:@{@"requestcommand":@"video_list",
                                                                              @"pagesize":@"30",
                                                                              @"pagenumber":@(page)}];
    if ([title length]) {
        [parametre setValue:title forKey:@"title"];
    }
    if ([da length]) {
        [parametre setValue:da forKey:@"times"];
    }
    
    
    [[HTTPClient sharedClient] postParameters:parametre success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *resultDict = [result JSONDictionary];
        
        self.videoLists = [PageDatas pageDatasWithJSON:resultDict parserClass:[New class]];
        NSLog(@"%@",result);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.collectionView reloadData];
            
        }else{
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
            self.tableView.infiniteScrollingView.enabled = self.videoLists.more;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.infiniteScrollingView stopAnimating];
        
    }];

}

#pragma mark -UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainView) {
        int page = scrollView.contentOffset.x/scrollView.frame.size.width;
        _pageControl.currentPage = page;
    }

}

#pragma mark -UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestSearchTitle:textField.text date:self.dateButton.titleLabel.text page:1];

    [textField resignFirstResponder];
    return YES;
}

#pragma mark -Action
- (IBAction)select:(id)sender
{
    UIView *master = UIView.new;
    master.frame = CGRectMake(0, 0, 320, 464);
    
    self.pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    _pickerView.datePickerMode = UIDatePickerModeDate;
    _pickerView.hidden = NO;
    [_pickerView setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    _pickerView.date = [NSDate date];
    
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
    
    [master addSubview:pickerToolbar];
    [master addSubview:_pickerView];
    
    if (IS_IPAD) {
        master.frame = CGRectMake(0, 0, 320, 270);
        pickerToolbar.frame = CGRectMake(0, 0, 320, 44);
        UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        viewController.view = master;
        viewController.contentSizeForViewInPopover = viewController.view.frame.size;
        self.popOverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
        [_popOverController presentPopoverFromRect:self.dateButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        self.pickerViewPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        [_pickerViewPopup addSubview:master];
        [_pickerViewPopup showInView:self.view];
        [_pickerViewPopup setBounds:CGRectMake(0,0,320, 464)];

    }
}

- (void)dismissPicker
{
    if (IS_IPAD) {
        [_popOverController dismissPopoverAnimated:YES];
    }else{
        [_pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
    }
}

- (void)doneButtonPressed{
    [self dismissPicker];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = _pickerView.date;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[formatter stringFromDate:date];
    [self.dateButton setTitle:str forState:UIControlStateNormal];
}


- (void)cancelButtonPressed{
    [self dismissPicker];
    [self.dateButton setTitle:@"选择时间" forState:UIControlStateNormal];
}


#pragma mark -UICollectionViewDelegate

- (NSInteger)collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section {
    return [self.videoLists.data count];
}

- ( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView {
    return 1 ;
}

- ( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath {
    
    NewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewCollectionCellIdentifier forIndexPath:indexPath];
    New *news = [self.videoLists.data objectAtIndex:indexPath.row];
    cell.news = news;
    return cell;
}


- (void)refreshMainView
{
    [[self.mainView subviews] enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if ([button isKindOfClass:[UIButton class]]) {
            CGRect rect = CGRectMake(0, 0, 768, 242);
            rect.origin.x = CGRectGetWidth(self.mainView.frame) * idx;
            button.frame = rect;
            self.mainView.contentSize = CGSizeMake(768*(idx+1),242);
            rect = self.mainView.frame;
            rect.size.width = 768;
            self.mainView.frame = rect;
        }
    }];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeRight || toInterfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
        [self refreshMainView];
    }
}

@end
