//
//  WXBaseModel.h
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLModel.h"


@interface WXBaseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *uniqueID;

@end
