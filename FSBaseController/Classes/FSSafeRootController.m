//
//  FSSafeRootController.m
//  FSBaseController
//
//  Created by Dongdong Fu on 2024/2/22.
//

#import "FSSafeRootController.h"

@interface FSSafeRootController ()<UIGestureRecognizerDelegate>

@end

@implementation FSSafeRootController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//必须这么做，与下面的gestureRecognizerShouldBegin:配合，解决一个bug：从这个页面跳转到二级、三级页面后，通过右滑手势退出页面到这页面时，偶现页面卡死，需要退到后台再回到前台时才会恢复且显示二级页面。
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] && gestureRecognizer == self.navigationController.interactivePopGestureRecognizer && self.navigationController.visibleViewController == self.navigationController.viewControllers[0]) {
        return NO;
    }
    return YES;
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
