//
//  CCKLineRootModel.h
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import <Foundation/Foundation.h>
#import "CCKLineModel.h"

typedef NS_ENUM(NSUInteger, CCKLineIndicator) {
    CCKLineIndicatorMA = 100, // MA线
    CCKLineIndicatorEMA, // EMA线
    CCKLineIndicatorBOLL, // BOLL线
    CCKLineIndicatorMACD = 104, // MACD线
    CCKLineIndicatorKDJ, // KDJ线
    CCKLineIndicatorRSI, // RSI
    CCKLineIndicatorWR, // WR
};
@interface CCKLineRootModel : NSObject

+ (instancetype)objectWithArray:(NSArray *)arr;
@property (nonatomic, copy) NSArray <CCKLineModel *> *models;

- (void)calculateIndicators:(CCKLineIndicator)key;
- (void)calculateNeedDrawTimeModel;

@end

