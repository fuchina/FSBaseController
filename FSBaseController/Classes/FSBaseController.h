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
#import "UIViewExt.h"
#import "FuSoft.h"
#import "FSKit.h"
#import "FSTrack.h"
#import "FSApp.h"
#import "FSBaseManager.h"

@interface FSBaseController : UIViewController

@property (nonatomic,strong) FSTapScrollView    *scrollView;

// manager继承自FSBaseManager，在子线程中执行
- (Class)baseManagerClass;
@property (nonatomic, strong) FSBaseManager     *manager;

- (void)showWaitView:(BOOL)show;

// UI创建入口，此时能获取安全区边际参数
- (void)componentWillMount;

// 网络请求前调用
- (void)renderBeforeRequest;

// 开始网络请求
- (void)requestServerData;

/**
 *  在有下拉刷新的app里，可以使用
 */
- (void)fitIOS15;

@end
