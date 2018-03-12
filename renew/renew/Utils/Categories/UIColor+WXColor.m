//
//  UIColor+WXColor.m
//  renew
//
//  Created by younghacker on 3/12/18.
//  Copyright © 2018 toureek. All rights reserved.
//


#import "UIColor+WXColor.h"


@implementation UIColor (WXColor)

+ (UIColor *)WX_AppMainColor
{
    return [self WX_ColorWithHexString:@"#41454B"];
}

+ (UIColor *)WX_MainContentTextColor
{
    return [self WX_ColorWithHexString:@"#333333"];
}

+ (UIColor *)WX_SubmainContentTextColor
{
    return [self WX_ColorWithHexString:@"#666666"];
}

+ (UIColor *)WX_PlaceholderTextColor
{
    return [self WX_ColorWithHexString:@"#999999"];
}

+ (UIColor *)WX_SeperatorLineColor
{
    return [self WX_ColorWithHexString:@"#CCCCCC"];
}


#pragma mark - Utils

+ (UIColor *)WX_ColorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            [NSException raise:@"Invalid color value"
                        format:@"Color value %@ is invalid.  It should be a hex value of the form #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *subString = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? subString : [NSString stringWithFormat:@"%@%@", subString, subString];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    
    return hexComponent / 255.0;
}

+ (UIImage *)WX_imageFactoryWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

