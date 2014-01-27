//
//  HTTPClient.m
//  News
//
//  Created by maruiduan on 14-1-18.
//  Copyright (c) 2014年 maruiduan. All rights reserved.
//

#import "HTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "NSDictionary+JSON.h"

//static NSString * const kAFAppJAVAAPIBaseURLString = @"http://61.187.200.222:8100";

static NSString * const kAFAppJAVAAPIBaseURLString = @"http://test.12326.com:8100";


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
    [[HTTPClient sharedClient] postPath:@"/baseproject/service/httpservices.htm" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
