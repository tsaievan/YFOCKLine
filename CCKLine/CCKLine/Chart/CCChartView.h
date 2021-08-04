//
//  CCChartView.h
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import <UIKit/UIKit.h>
#import "CCChartSegmentView.h"
#import "CCKLineRootModel.h"
#import "CCKLineConstant.h"

@protocol CCChartViewDataSource <NSObject>
- (void)stockDatasWithIndex:(NSInteger)index;
@end

@interface CCChartView : UIView
@property (nonatomic, strong) NSArray *itemModels;
@property (nonatomic, strong) CCChartSegmentView *segmentView;
- (instancetype)initWithItemModels:(NSArray *)itemModels;
/// 数据源
@property (nonatomic, weak) id <CCChartViewDataSource> dataSource;
- (void)reloadWithData:(CCKLineRootModel *)rootModel;
@end

@interface CCChartViewItemModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CCKLineType centerViewType;
+ (instancetype)itemModelWithTitle:(NSString *)title type:(CCKLineType)type;
@end

