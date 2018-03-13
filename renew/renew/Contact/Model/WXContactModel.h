//
//  WXContactModel.h
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXBaseModel.h"

#import <AddressBook/AddressBook.h>


@interface WXContactModel : WXBaseModel

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *indexTitle;

+ (NSArray *)loadAndSortAllContacts:(ABAddressBookRef)addressBook;

+ (NSArray *)filterSearchingResult:(NSArray *)sourceList matchKeywords:(NSString *)keywords;

@end
