//
//  UIColor+CCKLine.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import "UIColor+CCKLine.h"

@implementation  UIColor (CCKLine)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

#pragma mark - 所有图标的背景颜色
+ (UIColor *)backgroundColor {
    return [UIColor colorWithRGBHex:0x181c20];
}

#pragma mark - 辅助背景色
+ (UIColor *)assistBackgroundColor {
    return [UIColor colorWithRGBHex:0x1d2227];
}

#pragma mark - 涨的颜色
+ (UIColor *)upColor {
    return [UIColor colorWithRGBHex:0xff5353];
}

#pragma mark - 跌的颜色
+ (UIColor *)downColor {
    return [UIColor colorWithRGBHex:0x00b07c];
}

#pragma mark - 主文字颜色
+ (UIColor *)mainTextColor {
    return [UIColor colorWithRGBHex:0xe1e2e6];
}

#pragma mark - 分时线的颜色
+ (UIColor *)timeLineLineColor {
    return [UIColor whiteColor];
}

#pragma mark - 长按时的颜色
+ (UIColor *)longPressLineColor {
    return [UIColor colorWithRGBHex:0xe1e2e6];
}

#pragma mark - 辅助线颜色1
+ (UIColor *)line1Color {
    return [UIColor colorWithRGBHex:0xff783c];
}

#pragma mark - 辅助线颜色2
+ (UIColor *)line2Color {
    return [UIColor colorWithRGBHex:0x49a5ff];
}

#pragma mark - 辅助线颜色3
+ (UIColor *)line3Color {
    return [UIColor purpleColor];
}

@end
