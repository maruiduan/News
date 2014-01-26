//
//  NSDictionary+JSON.m
//  News
//
//  Created by maruiduan on 14-1-26.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

-(NSString*)JSONString
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    return str;
}

@end
