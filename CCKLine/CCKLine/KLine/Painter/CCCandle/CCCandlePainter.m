//
//  CCCandlePainter.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/9.
//

#import "CCCandlePainter.h"
#import "CCKLineGlobalVariable.h"
#import "UIColor+CCKLine.h"
#import "CCKLineModel.h"

@implementation CCCandlePainter

+ (CCMinMaxModel *)getMinMaxValue:(NSArray <CCKLineModel *> *)data {
    if (!data) {
        return [[CCMinMaxModel alloc] init];
    }
    __block CGFloat minAssert = data[0].Low.floatValue;
    __block CGFloat maxAssert = data[0].High.floatValue;
    [data enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        maxAssert = MAX(maxAssert, m.High.floatValue);
        minAssert = MIN(minAssert, m.Low.floatValue);
    }];
    return [CCMinMaxModel modelWithMin:minAssert max:maxAssert];
}

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray<CCKLineModel *> *)models minMax:(CCMinMaxModel *)minMaxModel {
    if (!models) {
        return;
    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH / minMaxModel.distance;
    
    /// 创建图层
    CCCandlePainter *sublayer = [[CCCandlePainter alloc] init];
    sublayer.frame = area;
    sublayer.contentsScale = UIScreen.mainScreen.scale;
    [models enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [CCKLineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [CCKLineGlobalVariable kLineGap]);
        CGFloat centerX = x + w / 2.f - [CCKLineGlobalVariable kLineGap] / 2.f;
        CGPoint highPoint = CGPointMake(centerX, maxH- (m.High.floatValue - minMaxModel.min) * unitValue);
        CGPoint lowPoint = CGPointMake(centerX, maxH - (m.Low.floatValue - minMaxModel.min) * unitValue);
        
        CGFloat h = fabsf(m.Open.floatValue - m.Close.floatValue) * unitValue;
        CGFloat y = maxH - (MAX(m.Open.floatValue, m.Close.floatValue) - minMaxModel.min) * unitValue;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w - [CCKLineGlobalVariable kLineGap], h)];
        [path moveToPoint:lowPoint];
        [path addLineToPoint:CGPointMake(centerX, y + h)];
        [path moveToPoint:highPoint];
        [path addLineToPoint:CGPointMake(centerX, y)];
        
        CAShapeLayer *l = [CAShapeLayer layer];
        l.contentsScale = UIScreen.mainScreen.scale;
        l.path = path.CGPath;
        l.lineWidth = CCKLineLineWidth;
        l.strokeColor = m.isUp ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
        l.fillColor = m.isUp ? [UIColor upColor].CGColor : [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }];
    [layer addSublayer:sublayer];
}

@end
