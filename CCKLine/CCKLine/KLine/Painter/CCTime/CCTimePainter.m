//
//  CCTimePainter.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/9/1.
//

#import "CCTimePainter.h"
#import "CCKLineGlobalVariable.h"
#import "UIColor+CCKLine.h"

@implementation CCTimePainter

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray<CCKLineModel *> *)models minMax:(CCMinMaxModel *)minMaxModel {
    CGFloat maxH = CGRectGetHeight(area);
    if (maxH <= 0) {
        return;
    }
    CCTimePainter *sublayer = [[CCTimePainter alloc] init];
    sublayer.backgroundColor = UIColor.assistBackgroundColor.CGColor;
    sublayer.frame = area;
    [layer addSublayer:sublayer];
    
    CGFloat w = [CCKLineGlobalVariable kLineWidth];
    [models enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isDrawTime) {
            return;
        }
        CGFloat x = idx * (w + [CCKLineGlobalVariable kLineGap]);
        CGFloat y = (maxH - [UIFont systemFontOfSize:12.f].lineHeight) / 2.f;
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = obj.V_HHMM;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.fontSize = 12.f;
        textLayer.foregroundColor = UIColor.grayColor.CGColor;
        textLayer.frame = CGRectMake(x - 50, y, 100, maxH);
        textLayer.contentsScale = UIScreen.mainScreen.scale;
        [sublayer addSublayer:textLayer];
    }];
}

@end
