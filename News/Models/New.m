//
//  New.m
//  News
//
//  Created by maruiduan on 14-1-18.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import "New.h"

@implementation New

- (void)parseObject:(NSDictionary *)data
{
    self.uuid = [data valueForKey:@"uuid"];
    self.title = [data valueForKey:@"title"];
    self.synopsis = [data valueForKey:@"synopsis"];
    self.author = [data valueForKey:@"author"];
    self.contents = [data valueForKey:@"contents"];
    self.videourl = [data valueForKey:@"videourl"];
    self.pickurl = [data valueForKey:@"pickurl"];
    self.addtime = [data valueForKey:@"addtime"];
}

@end
