//
//  UIColor+WXColor.h
//  renew
//
//  Created by younghacker on 3/12/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const kPlaceholderImageName;

@interface UIColor (WXColor)

+ (UIColor *)WX_AppMainColor;
+ (UIColor *)WX_MainContentTextColor;
+ (UIColor *)WX_SubmainContentTextColor;
+ (UIColor *)WX_PlaceholderTextColor;
+ (UIColor *)WX_SeperatorLineColor;


+ (UIColor *)WX_ColorWithHexString:(NSString *)hexString;
+ (UIImage *)WX_imageFactoryWithColor:(UIColor *)color;

@end


