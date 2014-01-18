//
//  New.h
//  News
//
//  Created by maruiduan on 14-1-18.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IParse.h"

@interface New : NSObject<IParse>

@property (nonatomic, strong) NSString *uuid;//新闻id
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *synopsis;//简介
@property (nonatomic, strong) NSString *author;//作者
@property (nonatomic, strong) NSString *contents;//文字内容
@property (nonatomic, strong) NSString *videourl;//视频链接（完整链接）
@property (nonatomic, strong) NSString *pickurl;//图片地址（完整链接）
@property (nonatomic, strong) NSString *addtime;//添加时间

@end
