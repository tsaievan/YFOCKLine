//
//  CCKLineConstant.h
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#ifndef CCKLineConstant_h
#define CCKLineConstant_h


#endif /* CCKLineConstant_h */

// K线图Y的View的宽度
#define CCKLineLinePriceViewWidth 47

// K线最大的宽度
#define CCKLineLineMaxWidth 20

// K线最小的宽度
#define CCKLineLineMinWidth 2

// K线图缩放界限
#define CCKLineScaleBound 0.02

// K线缩放因子
#define CCKLineScaleFactor 0.07

// 长按时的线的宽度
#define CCKLineLongPressVerticalViewWidth 0.5

// 上下影线宽度
#define CCKLineLineWidth 1

// KLine种类
typedef NS_ENUM(NSUInteger, CCKLineType) {
    CCKLineTypeKLine = 1, // K线
    CCKLineTypeTimeLine, // 分时图
    CCKLineTypeIndicator,
};


