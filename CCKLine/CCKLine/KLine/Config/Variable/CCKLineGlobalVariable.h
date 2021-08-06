//
//  CCKLineGlobalVariable.h
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/6.
//

#import <UIKit/UIKit.h>
#import "CCKLineConstant.h"

@interface CCKLineGlobalVariable : NSObject

/// K线图的宽度, 默认为2
+ (CGFloat)kLineWidth;
+ (void)setKLineWidth:(CGFloat)kLineWidth;


/// K线图的间隔, 默认1
+ (CGFloat)kLineGap;
+ (void)setKLineGap:(CGFloat)kLineGap;

/// MainView的高度占比, 默认0.5
+ (CGFloat)kLineMainViewRatio;
+ (void)setKLineMainViewRatio:(CGFloat)ratio;

/// VolumeView的高度占比, 默认为0.2
+ (CGFloat)kLineVolumeViewRatio;
+ (void)setKLineVolumeViewRatio:(CGFloat)ratio;
@end


