//
//  CCKLineRootModel.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import "CCKLineRootModel.h"
#import "CCKLineGlobalVariable.h"

@implementation CCKLineRootModel

+ (instancetype)objectWithArray:(NSArray *)arr {
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组, 请检查返回数据类型并手动适配");
    CCKLineRootModel *groupModel = [[CCKLineRootModel alloc] init];
    NSMutableArray *mArr = @[].mutableCopy;
    NSInteger index = 0;
    for (NSInteger i = arr.count - 1; i >= 0; i--) {
        NSDictionary *item = arr[i];
        CCKLineModel *model = [[CCKLineModel alloc] init];
        model.index = index;
        model.Timestamp = item[@"T"];
        model.Open = item[@"o"];
        model.High = item[@"h"];
        model.Low = item[@"l"];
        model.Close = item[@"c"];
        model.Volume = item[@"v"];
        model.prevModel = mArr.lastObject;
        [mArr addObject:model];
        index++;
    }
    groupModel.models = [mArr copy];
    [groupModel calculateIndicators:CCKLineIndicatorMACD];
    [groupModel calculateIndicators:CCKLineIndicatorMA];
    [groupModel calculateIndicators:CCKLineIndicatorKDJ];
    [groupModel calculateIndicators:CCKLineIndicatorRSI];
    [groupModel calculateIndicators:CCKLineIndicatorBOLL];
    [groupModel calculateIndicators:CCKLineIndicatorWR];
    [groupModel calculateIndicators:CCKLineIndicatorEMA];
    return groupModel;
}

- (void)calculateNeedDrawTimeModel {
    NSInteger gap = 50 / [CCKLineGlobalVariable kLineWidth] + [CCKLineGlobalVariable kLineGap];
    for (int i = 1; i < self.models.count; i++) {
        self.models[i].isDrawTime = i % gap == 0;
    }
}

- (void)calculateIndicators:(CCKLineIndicator)key {
    switch (key) {
        case CCKLineIndicatorMACD:
            [CCMACDModel calMACDWithData:self.models params:@[@"12", @"26", @"9"]];
            break;
        case CCKLineIndicatorMA:
            [CCMAModel calMAWithData:self.models params:@[@"10", @"30", @"60"]];
            break;
        case CCKLineIndicatorKDJ:
            [CCKDJModel calKDJWithData:self.models params:@[@"9", @"3", @"3"]];
            break;
        case CCKLineIndicatorRSI:
            [CCRSIModel calRSIWithData:self.models params:@[@"6", @"12", @"24"]];
            break;
        case CCKLineIndicatorWR:
            [CCWRModel calWRWithData:self.models params:@[@"6", @"10"]];
            break;
        case CCKLineIndicatorEMA:
            [CCEMAModel calEMAWithData:self.models params:@[@"7", @"30"]];
            break;
        case CCKLineIndicatorBOLL:
            [CCBOLLModel calBOLLWithData:self.models params:@[@"20", @"2"]];
            break;
    }
}

@end
