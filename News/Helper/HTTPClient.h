//
//  HTTPClient.h
//  News
//
//  Created by maruiduan on 14-1-18.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface HTTPClient : AFHTTPClient

+ (HTTPClient *)sharedClient;

- (void)postParameters:(NSDictionary *)dict
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)cancelALlRequest;

@end
