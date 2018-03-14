//
//  AFHTTPResponseSerializer+NetworkUtils.m
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "AFHTTPResponseSerializer+NetworkUtils.h"
#import <objc/runtime.h>


@implementation AFHTTPResponseSerializer (NetworkUtils)

- (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:@"application/json",
            @"text/json",
            @"text/javascript",
            @"text/html",
            @"text/plain",
            @"image/jpg",
            @"image/jpeg",
            @"image/png",
            @"image/pjpeg",
            @"image/x-png", nil];
}

@end
