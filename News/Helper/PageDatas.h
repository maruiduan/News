//
//  PageDatas.h
//  News
//
//  Created by maruiduan on 14-1-18.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IParse.h"

@interface PageDatas : NSObject

@property (nonatomic) NSInteger page;
@property (nonatomic, readonly) NSInteger total;
@property (nonatomic, readonly) NSInteger totalPage;

@property (nonatomic) BOOL more;
@property (nonatomic, strong) NSMutableArray *data;

+ (instancetype)pageDatasWithJSON:(NSDictionary *)json parserClass:(Class<IParse>)parserClass;

@end
