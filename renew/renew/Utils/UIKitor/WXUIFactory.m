//
//  WXUIFactory.m
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXUIFactory.h"


@implementation WXUIFactory

+ (UIButton *)buildButtonWithTitle:(NSString *)title
                   backgroundImage:(NSString *)backgroundImage
                              font:(UIFont *)font
                            target:(id)target
                            action:(SEL)action
{
    return [self buildButtonWithTitle:title backgroundImage:backgroundImage highlightImage:nil font:font target:target action:action];
}

+ (UIButton *)buildButtonWithTitle:(NSString *)title
                   backgroundImage:(NSString *)backgroundImage
                    highlightImage:(NSString *)highlightedImage
                              font:(UIFont *)font
                            target:(id)target
                            action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    if (highlightedImage) {
        [button setBackgroundImage:[UIImage imageNamed:highlightedImage]
                          forState:UIControlStateHighlighted];
    }
    button.titleLabel.font = font ? : [UIFont systemFontOfSize:16];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UILabel *)buildLabelWithTextColor:(UIColor *)textColor
                                font:(UIFont *)font
{
    return [self buildLabelWithTextColor:textColor
                                    font:font
                         backgroundColor:[UIColor clearColor]
                           textAlignment:NSTextAlignmentLeft
                           numberOfLines:1];
}

+ (UILabel *)buildLabelWithTextColor:(UIColor *)textColor
                                font:(UIFont *)font
                     backgroundColor:(UIColor *)backgroundColor
                       textAlignment:(NSTextAlignment)textAlignment
                       numberOfLines:(NSInteger)numberOfLines
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.font = font;
    label.backgroundColor = backgroundColor ? : [UIColor clearColor];
    label.textAlignment = textAlignment;
    label.numberOfLines = numberOfLines;
    
    return label;
}

+ (UITextField *)buildTextFiledWithPlaceholder:(NSString *)placeholder
                              placeholderColor:(UIColor *)placeholderColor
                                          font:(UIFont *)font
                                     textColor:(UIColor *)textColor
                                 textAlignment:(NSTextAlignment)textAlignment
                                    isPassword:(BOOL)isPassword
                                  keyboardType:(UIKeyboardType)keyboardType
{
    UITextField *textField = [[UITextField alloc] init];
    textField.keyboardType = keyboardType ? : UIKeyboardTypeDefault;
    textField.textAlignment = textAlignment ? : NSTextAlignmentLeft;
    textField.font = font ? : [UIFont systemFontOfSize:16];
    textField.textColor = textColor ? : [UIColor WX_MainContentTextColor];
    textField.placeholder = placeholder ? : @"";
    NSDictionary *style = @{NSForegroundColorAttributeName : (placeholderColor ? : [UIColor WX_PlaceholderTextColor])};
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder ? : @"" attributes:style];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = isPassword;
    
    return textField;
}

@end
