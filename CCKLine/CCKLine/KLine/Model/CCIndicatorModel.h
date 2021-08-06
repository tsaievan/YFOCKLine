//
//  CCIndicatorModel.h
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/5.
//

#import <Foundation/Foundation.h>
@class CCKLineModel;
NS_ASSUME_NONNULL_BEGIN

@interface CCMACDModel : NSObject
@property (nonatomic, strong) NSNumber *DIFF;
@property (nonatomic, strong) NSNumber *DEA;
@property (nonatomic, strong) NSNumber *MACD;
+ (void)calMACDWithData:(NSArray <CCKLineModel *> *)datas params:(NSArray *)params;
@end

@interface CCKDJModel : NSObject
@property (nonatomic, strong) NSNumber *K;
@property (nonatomic, strong) NSNumber *D;
@property (nonatomic, strong) NSNumber *J;
+ (void)calKDJWithData:(NSArray <CCKLineModel *> *)datas params:(NSArray *)params;
@end

@interface CCMAModel : NSObject
@property (nonatomic, strong) NSNumber *MA1;
@property (nonatomic, strong) NSNumber *MA2;
@property (nonatomic, strong) NSNumber *MA3;
+ (void)calMAWithData:(NSArray <CCKLineModel *> *)datas params:(NSArray *)params;
@end

@interface CCRSIModel : NSObject
@property (nonatomic, strong) NSNumber *RSI1;
@property (nonatomic, strong) NSNumber *RSI2;
@property (nonatomic, strong) NSNumber *RSI3;
+ (void)calRSIWithData:(NSArray <CCKLineModel *> *)datas params:(NSArray *)params;
@end

@interface CCBOLLModel : NSObject
@property (nonatomic, strong) NSNumber *UP;
@property (nonatomic, strong) NSNumber *MID;
@property (nonatomic, strong) NSNumber *LOW;
+ (void)calBOLLWithData:(NSArray <CCKLineModel *> *)datas params:(NSArray *)params;
@end

@interface CCWRModel : NSObject
@property (nonatomic, strong) NSNumber *WR1;
@property (nonatomic, strong) NSNumber *WR2;
+ (void)calWRWithData:(NSArray <CCKLineModel *> *)datas params:(NSArray *)params;
@end

@interface CCEMAModel : NSObject
@property (nonatomic, strong) NSNumber *EMA1;
@property (nonatomic, strong) NSNumber *EMA2;
+ (void)calEMAWithData:(NSArray <CCKLineModel *> *)datas params:(NSArray *)params;
@end

NS_ASSUME_NONNULL_END
