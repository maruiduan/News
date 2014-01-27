//
//  PageDatas.m
//  News
//
//  Created by maruiduan on 14-1-18.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import "PageDatas.h"

@interface PageDatas()

@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger totalPage;

@end

@implementation PageDatas

+ (instancetype)pageDatasWithJSON:(NSDictionary *)json parserClass:(Class<IParse>)parserClass
{
    PageDatas *pagingArray = [[[self class] alloc] init];
    
    NSArray *datas = [json objectForKey:@"data"];
    NSMutableArray *dataArray = [NSMutableArray array];
    [datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        id result = [[(id)parserClass alloc] init];
        [result parseObject:obj];
        [dataArray addObject:result];
    }];
    pagingArray.data = dataArray;
    pagingArray.page = [json[@"pagenumber"] intValue];
    pagingArray.totalPage = [json[@"totalpage"] intValue];
    pagingArray.total = [json[@"totalcounts"] intValue];
    pagingArray.more = pagingArray.page < pagingArray.totalPage;
    return pagingArray;
}

@end
