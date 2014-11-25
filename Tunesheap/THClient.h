//
//  THClient.h
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "AFHTTPSessionManager.h"

static NSString *baseURL = @"http://10.0.0.19:3000/api/v1/";

@interface THClient : AFHTTPSessionManager
+(instancetype)sharedClient;
@end
