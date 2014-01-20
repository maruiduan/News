//
//  HTTPClient.m
//  News
//
//  Created by maruiduan on 14-1-18.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import "HTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "JSONKit.h"

static NSString * const kAFAppJAVAAPIBaseURLString = @"https://alpha-api.app.net/";

@implementation HTTPClient

+ (HTTPClient *)sharedClient {
    static HTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kAFAppJAVAAPIBaseURLString]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    return self;
}

- (void)postParameters:(NSDictionary *)dict
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *para = [dict JSONString];
    NSDictionary *parameters = @{@"data":para};
    [[HTTPClient sharedClient] postPath:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)cancelALlRequest
{
    [[HTTPClient sharedClient].operationQueue cancelAllOperations];
}

@end
