//
//  UIAlertController+ClickDismiss.m
//  FSBaseController
//
//  Created by 扶冬冬 on 2024/6/21.
//

#import "UIAlertController+ClickDismiss.h"
#import "FSKit.h"
#import "FSTapGestureRecognizer.h"

@implementation UIAlertController (ClickDismiss)

- (BOOL)addTapEvent:(void (^)(UIAlertController *controller))clickDismiss {
    NSArray *views = [FSKit currentWindowScene].keyWindow.subviews;
    if (views.count > 0) {
        UIView *backView = views.lastObject;
        if (![backView isKindOfClass: NSClassFromString(@"UITransitionView")]) {
            return NO;
        }
        
        backView.userInteractionEnabled = YES;
        FSTapGestureRecognizer *tap = [[FSTapGestureRecognizer alloc] initWithTarget: self action: @selector(tap:)];
        tap.clickBack = clickDismiss;
        [backView addGestureRecognizer: tap];
    }
    return YES;
}

-(void)tap:(FSTapGestureRecognizer *)tap {
    if (tap.clickBack) {
        tap.clickBack(self);
    } else {
        [self dismissViewControllerAnimated: YES completion: nil];
    }
}

@end