//
//  FSPageBusinessController.h
//  FSAppPublic
//
//  Created by FudonFuchina on 2019/8/20.
//

#import "FSPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSPageBusinessController : UIViewController

@property (nonatomic,copy) void (^indexChanged)(FSPageBusinessController *viewController,NSInteger index);

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers frame:(CGRect)frame;

- (void)scrollToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
