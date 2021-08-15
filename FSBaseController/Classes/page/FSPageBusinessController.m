//
//  FSPageBusinessController.m
//  FSAppPublic
//
//  Created by FudonFuchina on 2019/8/20.
//

#import "FSPageBusinessController.h"
#import "FSKit.h"

@interface FSPageBusinessController ()
<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic,strong) NSArray    *vcs;

@end

@implementation FSPageBusinessController{
    FSPageController    *_pageController;
    NSInteger           _willIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat rgb = 245.0 / 255;
    self.view.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers frame:(CGRect)frame {
    BOOL isValidateArray = [viewControllers isKindOfClass:NSArray.class] && viewControllers.count;
    if (!isValidateArray) {
        return;
    }
    _fs_dispatch_main_queue_async(^{
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                           forKey: UIPageViewControllerOptionSpineLocationKey];
        self->_pageController = [[FSPageController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                    options:options];
        self.vcs = viewControllers;
        self->_pageController.view.frame = frame;
        
        [self->_pageController setViewControllers:@[viewControllers[0]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
        self->_pageController.delegate = self;
        self->_pageController.dataSource = self;
        [self addChildViewController:self->_pageController];
        [self.view addSubview:self->_pageController.view];
    });
}

- (void)scrollToIndex:(NSInteger)index {
    if (index < self.vcs.count) {
        UIViewController *vc = [self viewControllerAtIndex:index];
        if (!vc) {
            return;
        }
        
        UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
        if (index < _willIndex) {
            direction = UIPageViewControllerNavigationDirectionReverse;
        }
        _willIndex = index;
        [self->_pageController setViewControllers:@[vc]
                                  direction:direction
                                   animated:YES
                                 completion:nil];
    }
}

#pragma mark ----- UIPageViewControllerDataSource -----
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexForViewController:viewController];
    return [self viewControllerAtIndex:--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexForViewController:viewController];
    return [self viewControllerAtIndex:++index];
}

- (NSUInteger)indexForViewController:(UIViewController *)viewController{
    return [self.vcs indexOfObject:viewController];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index{
    if (index >= [self.vcs count]) {
        return nil;
    }
    if (index < 0) {
        return nil;
    }
    UIViewController *vc = [self.vcs objectAtIndex:index];
    return vc;
}

#pragma mark
#pragma mark ----- UIPageViewControllerDelegate -----
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
    UIViewController *nextVC = [pendingViewControllers firstObject];
    NSInteger index = [self.vcs indexOfObject:nextVC];
    if (index > self.vcs.count) {
        return;
    }
    if (index < 0) {
        index = 0;
    }
    _willIndex = index;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (completed) {
        if (self.indexChanged) {
            self.indexChanged(self, _willIndex);
        }
    }
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
