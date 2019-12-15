//
//  FSBaseController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBaseController.h"

typedef void(^FSBaseAlertBlock)(UIAlertView *bAlertView,NSInteger bIndex);

@interface FSBaseController ()

@property (nonatomic,strong) UIView                     *baseLoadingView;
@property (nonatomic,strong) UIView                     *baseBackView;
@property (nonatomic,assign) NSTimeInterval             baseTimeDelay;
@property (nonatomic,assign) CGFloat                    baseOnPropertyBase;

@property (nonatomic,copy) GZSAdvancedBlock             advancedBlock;

@end

@implementation FSBaseController{
    BOOL        _onceBase;
    UIView      *_backTapView;
}

- (void)dealloc{
#if TARGET_IPHONE_SIMULATOR
    NSString *title = [[NSString alloc] initWithFormat:@"%@ dealloc",NSStringFromClass(self.class)];
    NSLog(@"%@",title);
#else
#endif
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_onceBase) {
        _onceBase = YES;
        
        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:FSKit.appName style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // translucent为YES，self.view布局从屏幕顶部(0,0)开始，如果为NO会从导航栏底部开始
    self.navigationController.navigationBar.translucent = YES;
    
    [FSTrack event:NSStringFromClass([self class])];
    self.view.backgroundColor = RGBCOLOR(245, 245, 245, 1);
    
    _backTapView = [FSViewManager viewWithFrame:self.view.bounds backColor:nil];
    [self.view addSubview:_backTapView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionBase)];
    [_backTapView addGestureRecognizer:tap];
}

- (void)tapActionBase{
    [self.view endEditing:YES];
}

- (FSTapScrollView *)scrollView{
    if (!_scrollView) {
        // 纵坐标即使为0，子视图也是从导航栏下面开始布局
        _scrollView = [[FSTapScrollView alloc] initWithFrame:CGRectMake(0, _fs_statusAndNavigatorHeight(), WIDTHFC, HEIGHTFC - _fs_statusAndNavigatorHeight())];
        _scrollView.contentSize = CGSizeMake(WIDTHFC, HEIGHTFC + 10);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delaysContentTouches = NO;
        if (_backTapView) {
            [self.view insertSubview:_scrollView aboveSubview:_backTapView];
        }else{
            [self.view addSubview:_scrollView];
        }
    }
    return _scrollView;
}

- (void)setLetStatusBarWhite:(BOOL)letStatusBarWhite{
    _letStatusBarWhite = letStatusBarWhite;
    if (letStatusBarWhite) {
        if (IOSGE(7)) {
            [self.navigationController.navigationBar setTranslucent:YES];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        } else {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:130/255.0 blue:200/255.0 alpha:1];
        }
    }else{
        if (IOSGE(7)) {
            [self.navigationController.navigationBar setTranslucent:YES];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        } else {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:130/255.0 blue:200/255.0 alpha:1];
        }
    }
}

- (void)showWaitView:(BOOL)show{
    if (show) {
    // 隐藏其他比如暂无数据、无网络等的提示视图
//        [self hiddenErrorViews];
    }
    
    CGFloat blackWidth = MIN(WIDTHFC, HEIGHTFC) / 5;
    CGRect blackRect = CGRectMake(WIDTHFC / 2 - blackWidth / 2, HEIGHTFC / 2 - WIDTHFC / 10 - 50, blackWidth, blackWidth);
    
    if (show) {
        if (_baseLoadingView) {
            [self.view bringSubviewToFront:_baseLoadingView];
            _baseLoadingView.frame = [UIScreen mainScreen].bounds;
            _baseBackView.frame = blackRect;
        }else{
            _baseLoadingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [self.view insertSubview:_baseLoadingView atIndex:self.view.subviews.count];
            
            _baseBackView = [[UIView alloc] initWithFrame:blackRect];
            _baseBackView.alpha = .7;
            _baseBackView.backgroundColor = [UIColor blackColor];
            _baseBackView.layer.cornerRadius = 6;
            [_baseLoadingView addSubview:_baseBackView];
            
            UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            active.frame = CGRectMake(0, 0, _baseBackView.width, _baseBackView.height);
            [active startAnimating];
            [_baseBackView addSubview:active];
        }
    }else{
        _baseLoadingView.right = - WIDTHFC;
    }
}

- (void)addKeyboardNotificationWithAdvancedBlock:(GZSAdvancedBlock)advancedBlock{
    _advancedBlock = advancedBlock;
    [self addKeyboardNotificationWithBaseOn:0];
}

- (void)addKeyboardNotificationWithBaseOn:(CGFloat)baseOn{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybaordActionInPropertyBase:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybaordActionInPropertyBase:) name:UIKeyboardWillHideNotification object:nil];
    self.baseOnPropertyBase = baseOn;
}

- (void)keybaordActionInPropertyBase:(NSNotification *)notification{
    if (_advancedBlock) {
        _advancedBlock();
    }
    
    if (_scrollView) {
        self.scrollView.contentSize = [FSKit keyboardNotificationScroll:notification baseOn:self.baseOnPropertyBase];
    }else if (_baseTableView){
        self.baseTableView.contentSize = [FSKit keyboardNotificationScroll:notification baseOn:self.baseOnPropertyBase];
    }
}

- (FSVanView *)vanView{
    if (!_vanView) {
        _vanView = [[FSVanView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_vanView];
    }
    return _vanView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
