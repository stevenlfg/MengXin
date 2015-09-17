//
//  MengXinNetAPIClient.h
//  MengXin
//
//  Created by stevenlfg on 15/9/17.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;
@interface MengXinNetAPIClient : AFHTTPRequestOperationManager
+ (id)sharedJsonClient;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block;

@end
