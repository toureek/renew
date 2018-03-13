//
//  WXUIFactory.h
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WXUIFactory : NSObject

+ (UIButton *)buildButtonWithTitle:(NSString *)title
                   backgroundImage:(NSString *)backgroundImage
                              font:(UIFont *)font
                            target:(id)target
                            action:(SEL)action;

+ (UIButton *)buildButtonWithTitle:(NSString *)title
                   backgroundImage:(NSString *)backgroundImage
                    highlightImage:(NSString *)highlightedImage
                              font:(UIFont *)font
                            target:(id)target
                            action:(SEL)action;

+ (UILabel *)buildLabelWithTextColor:(UIColor *)textColor
                                font:(UIFont *)font;

+ (UILabel *)buildLabelWithTextColor:(UIColor *)textColor
                                font:(UIFont *)font
                     backgroundColor:(UIColor *)backgroundColor
                       textAlignment:(NSTextAlignment)textAlignment
                       numberOfLines:(NSInteger)numberOfLines;


+ (UITextField *)buildTextFiledWithPlaceholder:(NSString *)placeholder
                              placeholderColor:(UIColor *)placeholderColor
                                          font:(UIFont *)font
                                     textColor:(UIColor *)textColor
                                 textAlignment:(NSTextAlignment)textAlignment
                                    isPassword:(BOOL)isPassword
                                  keyboardType:(UIKeyboardType)keyboardType;

@end

