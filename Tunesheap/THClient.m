//
//  THClient.m
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "THClient.h"


static NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";

@interface JSONResponseSerializerWithData : AFJSONResponseSerializer
@end

@implementation JSONResponseSerializerWithData
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    id JSONObject = [super responseObjectForResponse:response data:data error:error];
    if (*error != nil) {
        NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
        if (data == nil) {
            userInfo[JSONResponseSerializerWithDataKey] = [NSData data];
        } else {
            userInfo[JSONResponseSerializerWithDataKey] = data;
        }
        NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
        (*error) = newError;
    }
    
    return (JSONObject);
}
@end


@implementation THClient

+(instancetype)sharedClient {
    static dispatch_once_t onceToken;
    static THClient *sharedClient;
    dispatch_once(&onceToken, ^{
        sharedClient = [[THClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        securityPolicy.allowInvalidCertificates = YES;
        sharedClient.securityPolicy = securityPolicy;
        sharedClient.responseSerializer = [JSONResponseSerializerWithData serializer];
        [sharedClient.responseSerializer setAcceptableContentTypes:[sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"]];
        [sharedClient setSessionDidReceiveAuthenticationChallengeBlock:
         ^NSURLSessionAuthChallengeDisposition(NSURLSession *session,
                                               NSURLAuthenticationChallenge *challenge,
                                               NSURLCredential *__autoreleasing *credential) {
             return NSURLSessionAuthChallengePerformDefaultHandling;
         }
         ];
    });
    return sharedClient;
}
@end
