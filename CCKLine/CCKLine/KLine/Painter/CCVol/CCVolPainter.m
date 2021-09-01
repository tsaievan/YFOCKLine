//
//  CCVolPainter.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/9/1.
//

#import "CCVolPainter.h"
#import "CCKLineGlobalVariable.h"
#import "UIColor+CCKLine.h"

@implementation CCVolPainter

+ (CCMinMaxModel *)getMinMaxValue:(NSArray<CCKLineModel *> *)data {
    if (!data) {
        return [[CCMinMaxModel alloc] init];
    }
    __block CGFloat minAssert = 0.f;
    __block CGFloat maxAssert = 0.f;
    [data enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        maxAssert = MAX(maxAssert, m.Volume.floatValue);
    }];
    return [CCMinMaxModel modelWithMin:minAssert max:maxAssert];
}

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray<CCKLineModel *> *)models minMax:(CCMinMaxModel *)minMaxModel {
    if (!models) {
        return;
    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH / minMaxModel.distance;
    
    CCVolPainter *sublayer = [[CCVolPainter alloc] init];
    sublayer.frame = area;
    [models enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [CCKLineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [CCKLineGlobalVariable kLineGap]);
        CGFloat h = fabs(m.Volume.floatValue - minMaxModel.min) * unitValue;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, maxH - h, w - [CCKLineGlobalVariable kLineGap], h)];
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path.CGPath;
        l.lineWidth = CCKLineLineWidth;
        l.strokeColor = m.isUp ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
        l.fillColor = m.isUp ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
        [sublayer addSublayer:l];
    }];
    [layer addSublayer:sublayer];
}

@end
    
