//
//  VideoController.h
//  News
//
//  Created by maruiduan on 14-1-19.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoController : UIViewController

@property (nonatomic, strong) NSString *url;

- (instancetype)initWithURL:(NSString *)url;

- (IBAction)dismiss;


@end
