//
//  CCIndicatorModel.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/5.
//

#import "CCIndicatorModel.h"
#import "CCKLineModel.h"

@implementation CCMACDModel
+ (double)emaWithLastEma:(double)lastEma close:(double)close n:(int)n {
    double a = 2.0 / (float)(n + 1);
    return a * close + (1 - a) * lastEma;
}

+ (double)deaWithLastDea:(double)lastDea curDiff:(double)curDiff day:(int)n {
    double a = 2.0 / (float)(n + 1);
    return a * curDiff + (1 - a) * lastDea;
}


/// 计算macd指标, 快速和慢速移动平均线的周期分别取12和26
/// @param datas 计算数据
+ (void)calMACDWithData:(NSArray<CCKLineModel *> *)datas params:(NSArray *)params {
    if (params.count != 3) {
        return;
    }
    NSMutableArray *ema12 = @[].mutableCopy;
    NSMutableArray *ema26 = @[].mutableCopy;
    NSMutableArray *diffs = @[].mutableCopy;
    NSMutableArray *deas = @[].mutableCopy;
    NSMutableArray *bars = @[].mutableCopy;
    
    int p1 = [params[0] intValue];
    int p2 = [params[1] intValue];
    int p3 = [params[2] intValue];
    
    for (int i = 0; i < datas.count; i++) {
        CCKLineModel *t = datas[i];
        double c = t.Close.doubleValue;
        if (i == 0) {
            [ema12 addObject:@(c)];
            [ema26 addObject:@(c)];
            [deas addObject:@(0)];
        }else {
            [ema12 addObject:@([self emaWithLastEma:[ema12[i - 1] doubleValue] close:c n:p1])];
            [ema26 addObject:@([self emaWithLastEma:[ema26[i - 1] doubleValue] close:c n:p2])];
        }
        [diffs addObject:@([ema12[i] doubleValue] - [ema26[i] doubleValue])];
        if (i != 0) {
            [deas addObject:@([self deaWithLastDea:[deas[i - 1] doubleValue] curDiff:[diffs[i] doubleValue] day:p3])];
        }
        [bars addObject:@(([diffs[i] doubleValue] - [deas[i] doubleValue]) * 2)];
    }
    [datas enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCMACDModel *m = [[CCMACDModel alloc] init];
        m.DIFF = diffs[idx];
        m.DEA = deas[idx];
        m.MACD = bars[idx];
        obj.MACD = m;
    }];
}
@end

@implementation CCKDJModel

/// 计算kdj指标, rsv的周期为9日
/// @param datas datas
/// 二维数组类型, 其中内层数组包含3个元素值, 第一个值表示当前Tick的最高价格, 第二个表示当前Tick的最低价格, 第三个表示当前Tick的收盘价格
+ (void)calKDJWithData:(NSArray<CCKLineModel *> *)datas params:(NSArray *)params {
    if (params.count != 3) {
        return;
    }
    NSMutableArray <CCKLineModel *> *nineDaysDatas = @[].mutableCopy;
    int days = [params[0] intValue];
    double m1 = 1.0 / [params[1] doubleValue];
    double m2 = 1.0 / [params[2] doubleValue];
    
    NSMutableArray <NSNumber *> *rsvs = @[].mutableCopy;
    NSMutableArray <NSNumber *> *ks = @[].mutableCopy;
    NSMutableArray <NSNumber *> *ds = @[].mutableCopy;
    NSMutableArray <NSNumber *> *js = @[].mutableCopy;
    
    for (int i = 0; i < datas.count; i++) {
        CCKLineModel *t = datas[i];
        double c = [t.Close doubleValue];
        [nineDaysDatas addObject:t];
        double max = 0;
        double min = INFINITY;
        for (CCKLineModel *mn in nineDaysDatas) {
            max = MAX(mn.High.doubleValue, max);
            min = MIN(mn.Low.doubleValue, min);
        }
        if (max == min) {
            [rsvs addObject:@(0)];
        }else {
            double v = ((c - min) / (max - min) * 100);
            [rsvs addObject:@(v)];
        }
        if (nineDaysDatas.count == days) {
            [nineDaysDatas removeObjectAtIndex:0];
        }
        if (i == 0) {
            double k = [rsvs[i] doubleValue];
            [ks addObject:@(k)];
            double d = k;
            [ds addObject:@(d)];
            double j = 3.0 * k - 2.0 * d;
            [js addObject:@(j)];
        }else {
            double k = (1 - m1) * [ks[i - 1] doubleValue] + m1 * [rsvs[i] doubleValue];
            [ks addObject:@(k)];
            double d = (1 - m2) * [ds[i - 1] doubleValue] + m2 * k;
            [ds addObject:@(d)];
            double j = 3.0 * k - 2.0 * d;
            [js addObject:@(j)];
        }
    }
    [datas enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCKDJModel *m = [[CCKDJModel alloc] init];
        m.K = ks[idx];
        m.D = ds[idx];
        m.J = js[idx];
        m.RSV = rsvs[idx];
        obj.KDJ = m;
    }];
    
}
@end

@implementation CCMAModel
+ (void)calMAWithData:(NSArray<CCKLineModel *> *)datas params:(NSArray *)params {
    if (params.count == 0) {
        return;
    }
    NSArray *days = params;
    NSMutableDictionary *result = @{}.mutableCopy;
    NSMutableDictionary *paramData = @{}.mutableCopy;
    for (int i = 0; i < datas.count; i++) {
        CCKLineModel *t = datas[i];
        double c = [t.Close doubleValue];
        for (NSString *d in days) {
            NSString *ma = d;
            if ([result objectForKey:ma] == nil) {
                result[ma] = @[].mutableCopy;
            }
            if ([paramData objectForKey:ma] == nil) {
                paramData[ma] = @[].mutableCopy;
            }
            NSMutableArray *mas = result[ma];
            NSMutableArray *nma = paramData[ma];
            [nma addObject:@(c)];
            
            if (nma.count == d.integerValue) {
                double nowMa = 0.0;
                for (NSNumber *n in nma) {
                    nowMa += [n doubleValue];
                }
                nowMa = nowMa / [d doubleValue];
                [mas addObject:@(nowMa)];
                [nma removeObjectAtIndex:0];
            }else {
                double nowMa = 0.0;
                for (NSNumber *n in nma) {
                    nowMa += [n doubleValue];
                }
                nowMa = nowMa / (float)nma.count;
                [mas addObject:@(nowMa)];
            }
        }
    }
    [datas enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCMAModel *m = [[CCMAModel alloc] init];
        m.MA1 = result[@"10"][idx];
        m.MA2 = result[@"30"][idx];
        m.MA3 = result[@"60"][idx];
        obj.MA = m;
    }];
}

@end

@implementation CCRSIModel

/// 计算rsi指标, 分别返回以6日, 12日, 24日为参考基期的RSI值
/// @param datas 一维数组类型, 每个元素为当前Tick的收盘价格
+ (void)calRSIWithData:(NSArray<CCKLineModel *> *)datas params:(NSArray *)params {
    if (params.count == 0) {
        return;
    }
    double lastClosePx = datas[0].Close.floatValue;
    NSArray *days = params;
    NSMutableDictionary *result = @{}.mutableCopy;
    
    for (int i = 0; i < datas.count; i++) {
        CCKLineModel *t = datas[i];
        double c = t.Close.floatValue;
        
        double m = MAX(c - lastClosePx, 0);
        double a = fabs(c - lastClosePx);
        
        for (NSString *d in days) {
            NSString *lastSm = [NSString stringWithFormat:@"lastSm%@", d];
            NSString *lastSa = [NSString stringWithFormat:@"lastSa%@", d];
            NSString *rsi = [NSString stringWithFormat:@"rsi%@", d];
            if ([result objectForKey:rsi] == nil) {
                result[lastSm] = @(0);
                result[lastSa] = @(0);
                result[rsi] = @[@(0)].mutableCopy;
            }else {
                result[lastSm] = @((m + ([d doubleValue] - 1) * [result[lastSm] doubleValue]) / [d doubleValue]);
                result[lastSa] = @((a + ([d doubleValue] - 1) * [result[lastSa] doubleValue]) / [d doubleValue]);
                NSMutableArray *ary = result[rsi];
                if ([result[lastSa] doubleValue] != 0) {
                    [ary addObject:@([result[lastSm] doubleValue] / [result[lastSa] doubleValue] * 100.0)];
                }else {
                    [ary addObject:@(0)];
                }
            }
        }
        lastClosePx = c;
    }
    [datas enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCRSIModel *m = [[CCRSIModel alloc] init];
        m.RSI1 = result[@"rsi6"][idx];
        m.RSI2 = result[@"rsi12"][idx];
        m.RSI3 = result[@"rsi24"][idx];
        obj.RSI = m;
    }];
}

@end

@implementation CCBOLLModel

/// 计算boll指标, ma的周期为20日
/// @param datas datas
/// 一维数组类型, 每个元素的为当前Tick的收盘价格
+ (void)calBOLLWithData:(NSArray<CCKLineModel *> *)datas params:(NSArray *)params {
    if (params.count != 2) {
        return;
    }
    int maDays = [params[0] intValue];
    int k = [params[1] intValue];
    NSMutableArray <NSNumber *> *ups = @[].mutableCopy;
    NSMutableArray <NSNumber *> *mas = @[].mutableCopy;
    NSMutableArray <NSNumber *> *lows = @[].mutableCopy;
    NSMutableArray *nma = @[].mutableCopy;
    
    for (int i = 0; i < datas.count; i++) {
        CCKLineModel *t = datas[i];
        double c = t.Close.floatValue;
        [nma addObject:@(c)];
        if (nma.count == maDays) {
            NSNumber *mb = mas[i - 1];
            double nowMa = 0.0;
            double sumMD = 0.0;
            for (NSNumber *n in nma) {
                nowMa += [n doubleValue];
                sumMD += pow([n doubleValue] - [mb doubleValue], 2);
            }
            nowMa = nowMa / (float)maDays;
            [mas addObject:@(nowMa)];
            [nma removeObjectAtIndex:0];
            
            double md = sqrt(sumMD / maDays);
            double up = [mb doubleValue] + k * md;
            double dn = [mb doubleValue] - k * md;
            [ups addObject:@(up)];
            [lows addObject:@(dn)];
        }else {
            [mas addObject:@(c)];
            [ups addObject:@(c)];
            [lows addObject:@(c)];
        }
    }
    [datas enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCBOLLModel *m = [[CCBOLLModel alloc] init];
        m.UP = ups[idx];
        m.MID = mas[idx];
        m.LOW = lows[idx];
        obj.BOLL = m;
    }];
}

@end

@implementation CCWRModel
+ (void)calWRWithData:(NSArray<CCKLineModel *> *)datas params:(NSArray *)params {
    if (params.count == 0) {
        return;
    }
    NSArray *days = params;
    NSMutableDictionary *paramData = @{}.mutableCopy;
    NSMutableDictionary *result = @{}.mutableCopy;
    for (int i = 0; i < datas.count; i++) {
        CCKLineModel *t = datas[i];
        double c = t.Close.floatValue;
        for (NSString *d in days) {
            NSString *wr = [NSString stringWithFormat:@"wr%@", d];
            if ([result objectForKey:wr] == nil) {
                result[wr] = @[].mutableCopy;
            }
            if ([paramData objectForKey:wr] == nil) {
                paramData[wr] = @[].mutableCopy;
            }
            NSMutableArray *wrs = result[wr];
            NSMutableArray *nwr = paramData[wr];
            
            [nwr addObject:t];
            double max = 0;
            double min = INFINITY;
            for (CCKLineModel *mn in nwr) {
                max = MAX(mn.High.floatValue, max);
                min = MIN(mn.Low.floatValue, min);
            }
            double nowWR = max > min ? 100.0 * (max - c) / (max - min) : 100;
            [wrs addObject:@(nowWR)];
            if (nwr.count == d.integerValue) {
                [nwr removeObjectAtIndex:0];
            }
        }
    }
    [datas enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCWRModel *m = [[CCWRModel alloc] init];
        m.WR1 = result[@"wr6"][idx];
        m.WR2 = result[@"wr10"][idx];
        obj.WR = m;
    }];
}

@end

@implementation CCEMAModel

+ (double)emaWithLastEma:(double)lastEma close:(double)close n:(int)n {
    double a = 2.0 / (float)(n + 1);
    return a * close + (1 - a) * lastEma;
}

+ (void)calEMAWithData:(NSArray<CCKLineModel *> *)datas params:(NSArray *)params {
    if (params.count == 0) {
        return;
    }
    NSArray *days = params;
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < datas.count; i++) {
        CCKLineModel *model = datas[i];
        CGFloat close = model.Close.floatValue;
        for (NSString *day in days) {
            NSString *key = [NSString stringWithFormat:@"ema%@", day];
            if ([resultDict objectForKey:key] == nil) {
                resultDict[key] = @[].mutableCopy;
            }
            NSMutableArray *emaArray = resultDict[key];
            if (i == 0) {
                [emaArray addObject:@(close)];
            }else {
                [emaArray addObject:@([self emaWithLastEma:[emaArray[i - 1] doubleValue] close:close n:[day intValue]])];
            }
        }
    }
    [datas enumerateObjectsUsingBlock:^(CCKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCEMAModel *m = [[CCEMAModel alloc] init];
        m.EMA1 = resultDict[@"ema7"][idx];
        m.EMA2 = resultDict[@"ema30"][idx];
        obj.EMA = m;
    }];
}

@end
