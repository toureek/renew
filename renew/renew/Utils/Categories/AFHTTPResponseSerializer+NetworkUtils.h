//
//  AFHTTPResponseSerializer+NetworkUtils.h
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


@interface AFHTTPResponseSerializer (NetworkUtils)

- (NSSet *)acceptableContentTypes;

@end
