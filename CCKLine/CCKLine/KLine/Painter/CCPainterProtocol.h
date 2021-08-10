//
//  CCPainterProtocol.h
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/9.
//

#ifndef CCPainterProtocol_h
#define CCPainterProtocol_h
#import "CCMinMaxModel.h"
#import "CCKLineModel.h"

@protocol CCPainterProtocol <NSObject>

@required
+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray <CCKLineModel *> *)models minMax:(CCMinMaxModel*)minMaxModel;

@optional

/// 获取边界值
+ (CCMinMaxModel *)getMinMaxValue:(NSArray <CCKLineModel *> *)data;

+ (NSAttributedString *)getText:(CCKLineModel *)model;

@end

@protocol CCVerticalTextPainterProtocol <NSObject>

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area minMax:(CCMinMaxModel *)minMaxModel;

@end

#endif /* CCPainterProtocol_h */
