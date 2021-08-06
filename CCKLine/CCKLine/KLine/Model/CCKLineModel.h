//
//  CCKLineModel.h
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import <Foundation/Foundation.h>
#import "CCIndicatorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCKLineModel : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) CCKLineModel *prevModel;

@property (nonatomic, strong) NSNumber *Timestamp;
@property (nonatomic, strong) NSNumber *Open;
@property (nonatomic, strong) NSNumber *Close;
@property (nonatomic, strong) NSNumber *High;
@property (nonatomic, strong) NSNumber *Low;
@property (nonatomic, strong) NSNumber *Volume;

@property (nonatomic, strong) CCMACDModel *MACD;
@property (nonatomic, strong) CCKDJModel *KDJ;
@property (nonatomic, strong) CCMAModel *MA;
@property (nonatomic, strong) CCEMAModel *EMA;
@property (nonatomic, strong) CCRSIModel *RSI;
@property (nonatomic, strong) CCBOLLModel *BOLL;
@property (nonatomic, strong) CCWRModel *WR;

@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, assign) BOOL isDrawTime;

@property (nonatomic, copy) NSString *V_Date;
@property (nonatomic, copy) NSString *V_HHMM;
@property (nonatomic, copy) NSAttributedString *V_Price;
@property (nonatomic, copy) NSAttributedString *V_MA;
@property (nonatomic, copy) NSAttributedString *V_EMA;
@property (nonatomic, copy) NSAttributedString *V_BOLL;
@property (nonatomic, copy) NSAttributedString *V_Volume;
@property (nonatomic, copy) NSAttributedString *V_MACD;
@property (nonatomic, copy) NSAttributedString *V_KDJ;
@property (nonatomic, copy) NSAttributedString *V_WR;
@property (nonatomic, copy) NSAttributedString *V_RSI;

@end

NS_ASSUME_NONNULL_END
