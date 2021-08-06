//
//  CCKLineGlobalVariable.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/6.
//

#import "CCKLineGlobalVariable.h"
/// K线图的宽度, 默认为2
static CGFloat kCCKLineLineWidth = 2;
/// K线图的间隔, 默认1
static CGFloat kCCKlineLineGap = 1;
/// MainView的高度占比, 默认为0.5
static CGFloat kCCKlineMainViewRatio = 0.5;
/// VolumeView的高度占比, 默认为0.2
static CGFloat kCCKLineVolumeViewRatio = 0.2;


@implementation CCKLineGlobalVariable


/// K线图的宽度, 默认为2
+ (CGFloat)kLineWidth {
    return kCCKLineLineWidth;
}

+ (void)setKLineWidth:(CGFloat)kLineWidth {
    if (kLineWidth > CCKLineLineMaxWidth) {
        kLineWidth = CCKLineLineMaxWidth;
    }else if (kLineWidth < CCKLineLineMinWidth) {
        kLineWidth = CCKLineLineMinWidth;
    }
    kCCKLineLineWidth = kLineWidth;
}


/// K线图的间隔, 默认为1
+ (CGFloat)kLineGap {
    return kCCKlineLineGap;
}

+ (void)setKLineGap:(CGFloat)kLineGap {
    kCCKlineLineGap = kLineGap;
}

/// MainView的高度占比, 默认为0.5
+ (CGFloat)kLineMainViewRatio {
    return kCCKlineMainViewRatio;
}

+ (void)setKLineMainViewRatio:(CGFloat)ratio {
    kCCKlineMainViewRatio = ratio;
}


/// VolumeView的高度占比, 默认为0.2
+ (CGFloat)kLineVolumeViewRatio {
    return kCCKLineVolumeViewRatio;
}

+ (void)setKLineVolumeViewRatio:(CGFloat)ratio {
    kCCKLineVolumeViewRatio = ratio;
}

@end
