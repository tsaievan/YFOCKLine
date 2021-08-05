//
//  CCChartViewController.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import "CCChartViewController.h"
#import "UIColor+CCKLine.h"
#import "CCChartView.h"
#import <Masonry/Masonry.h>

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCREEN_MAX_LENGTH MAX(kScreenWidth, kScreenHeight)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH >= 812.0)
#define defer __strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^

@interface CCChartViewController () <CCChartViewDataSource>
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) CCChartView *stockChartView;
@end

static void blockCleanUp(__strong void(^*block)(void)) {
    (*block)();
}

@implementation CCChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.backgroundColor;
    /// 初始化K线的view
    self.stockChartView = [[CCChartView alloc] initWithItemModels:@[
        [CCChartViewItemModel itemModelWithTitle:@"指标" type:CCKLineTypeIndicator],
        [CCChartViewItemModel itemModelWithTitle:@"分时" type:CCKLineTypeTimeLine],
        [CCChartViewItemModel itemModelWithTitle:@"1分" type:CCKLineTypeKLine],
        [CCChartViewItemModel itemModelWithTitle:@"5分" type:CCKLineTypeKLine],
        [CCChartViewItemModel itemModelWithTitle:@"15分" type:CCKLineTypeKLine],
        [CCChartViewItemModel itemModelWithTitle:@"30分" type:CCKLineTypeKLine],
        [CCChartViewItemModel itemModelWithTitle:@"1小时" type:CCKLineTypeKLine],
        [CCChartViewItemModel itemModelWithTitle:@"6小时" type:CCKLineTypeKLine],
        [CCChartViewItemModel itemModelWithTitle:@"日线" type:CCKLineTypeKLine],
    ]];
    self.stockChartView.dataSource = self;
    [self.view addSubview:self.stockChartView];
    [self.stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_X) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 30, 0, 0));
        }else {
            make.edges.mas_equalTo(self.view);
        }
    }];
    
    /// 双击屏幕退出全屏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /// 可自定义: 默认选中哪个tab
    self.stockChartView.segmentView.selectedIndex = 5;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 实现数据源方法
- (void)stockDatasWithIndex:(NSInteger)index {
    [self.indicatorView startAnimating];
    NSDictionary *dict = @{
        @1 : @"1m",
        @2 : @"1m",
        @3 : @"5m",
        @4 : @"15m",
        @5 : @"30m",
        @6 : @"1h",
        @7 : @"6h",
        @8 : @"1d",
    };
    NSString *url = [NSString stringWithFormat:@"https://data.mifengcha.com/api/v3/kline?api_key=SWN2K2F9B8E2UWTJ9SRHU4ULDGAZCEL937NKDRU6&desc=gate-io_BTC_USDT&interval=%@", dict[@(index)]];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        defer {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.indicatorView stopAnimating];
            });
        };
        if (error) {
            return;
        }
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error) {
            return;
        }
        CCKLineRootModel *groupModel = [CCKLineRootModel objectWithArray:dataArray];
        [weakSelf.stockChartView reloadWithData:groupModel];
    }];
    [task resume];
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.view addSubview:_indicatorView];
        _indicatorView.frame = CGRectMake(0, 0, 100, 100);
        _indicatorView.center = self.view.center;
    }
    return _indicatorView;
}

@end
