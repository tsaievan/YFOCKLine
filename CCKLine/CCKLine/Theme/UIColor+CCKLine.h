//
//  UIColor+CCKLine.h
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import <UIKit/UIKit.h>

@interface UIColor (CCKLine)

/// 所有图表的背景颜色
+ (UIColor *)backgroundColor;

/// 辅助背景色
+ (UIColor *)assistBackgroundColor;

/// 涨的颜色
+ (UIColor *)upColor;

/// 跌的颜色
+ (UIColor *)downColor;

/// 主文字颜色
+ (UIColor *)mainTextColor;

/// 分时线的颜色
+ (UIColor *)timeLineLineColor;

/// 长按时线的颜色
+ (UIColor *)longPressLineColor;

/// 辅助线颜色1
+ (UIColor *)line1Color;

/// 辅助线颜色2
+ (UIColor *)line2Color;

/// 辅助线颜色3
+ (UIColor *)line3Color;

@end

