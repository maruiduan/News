//
//  NSString+JSON.m
//  News
//
//  Created by maruiduan on 14-1-20.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

- (NSDictionary *)JSONDictionary
{
    NSError *error = nil;
    NSData *data =  [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return dict;
}

@end
