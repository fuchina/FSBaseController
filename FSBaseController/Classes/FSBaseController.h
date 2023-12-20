//
//  FSBaseController.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSNavigationController.h"
#import "FSTapScrollView.h"
#import "FSViewManager.h"
#import "FuSoft.h"
#import "FSKit.h"
#import "FSTrack.h"
#import "FSApp.h"
#import "FSBaseManager.h"
#import "FSView.h"
#import "FSUIAdapter.h"

@interface FSBaseController : UIViewController

+ (void)fitIOS15;

@property (nonatomic,strong) FSTapScrollView    *scrollView;

// manager继承自FSBaseManager，在子线程中执行
- (Class)baseManagerClass;
@property (nonatomic, strong) FSBaseManager     *manager;

- (void)showWaitView:(BOOL)show;

// UI创建入口，此时能获取安全区边际参数
- (void)componentWillMount;

// 开始网络请求
- (void)baseHandleDatas;

// 开始渲染UI
- (void)baseDesignViews;

/**
 *  在有下拉刷新的app里，可以使用
 */
- (void)fitIOS15;

/**
 *  底部视图
 */
- (FSView *)fs_bottomView;

@end
