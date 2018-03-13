//
//  WXContactModel.m
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXContactModel.h"
#import "NSString+Utils.h"

#import "pinyin.h"


@implementation WXContactModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"identifier" : @"id" };
}

#pragma mark - Public methods

// 获取系统通讯录的联系人，并按字母排序为 A~Z的顺序
// 返回数组
// 第一个返回值为titleIndexList  A~Z
// 第二个返回值为dataDictionary  A对应的数组 B对应的数组... 是个K-V结构的字典
+ (NSArray *)loadAndSortAllContacts:(ABAddressBookRef)addressBook
{
    // get all-contactList
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:numberOfPeople];
    for (int i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *peopleName = [NSString stringWithFormat:@"%@%@", (lastName ? : @""), (firstName ? : @"")];
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
        
        WXContactModel *contact = [[WXContactModel alloc] init];
        contact.name = [peopleName stringByStrippingWhitespace] ? : @"";
        contact.phone = personPhone ? : @"";
        contact.indexTitle = [contact.name isEqualToString:@""] ? @"#" : [contact.name uppercasePinYinFirstLetter];
        [list addObject:contact];
    }
    
    // sort all contacts
    if (list && list.count > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        for (WXContactModel *item in list) {
            NSString *indexTitle = item.indexTitle;
            NSMutableArray *tempArray = params[indexTitle];
            if (!tempArray) {
                tempArray = [NSMutableArray arrayWithCapacity:2];
                [params setObject:tempArray forKey:indexTitle];
            }
            [tempArray addObject:item];
        }
        
        NSArray *sortedKeys =[[params allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSMutableArray *sortedValues = [NSMutableArray array];
        for (NSString *key in sortedKeys) {
            [sortedValues addObject:params[key]];
        }
        
        NSArray *titleIndexList = [sortedKeys copy];
        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
        for (int i = 0; i < sortedValues.count; i++) {
            [dataDictionary setObject:sortedValues[i] forKey:sortedKeys[i]];
        }
        
        return @[titleIndexList, dataDictionary];
    }
    
    return @[[NSArray new], [NSMutableDictionary dictionaryWithCapacity:2]];
}

+ (NSArray *)filterSearchingResult:(NSArray *)sourceList matchKeywords:(NSString *)keywords
{
    if (!sourceList || (sourceList.count == 0)) {
        return [NSArray new];
    }
    
    NSMutableArray *finalList = [NSMutableArray arrayWithCapacity:4];
    NSString *keyText = [keywords lowercaseString];
    for (NSArray *arrayList in sourceList) {
        for (WXContactModel *contact in arrayList) {
            if ([[contact.name lowercaseString] containsString:keyText ] ||
                [[contact.phone lowercaseString] containsString:keyText]) {
                [finalList addObject:contact];
            }
        }
    }
    
    return [finalList copy];
}

@end

