//
//  FSTextViewController.m
//  myhome
//
//  Created by FudonFuchina on 2017/8/15.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSTextViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIViewExt.h"
#import "FSApp.h"

@interface FSTextViewController ()

@property (nonatomic,strong) UITextView     *textView;

@end

@implementation FSTextViewController{
    BOOL    _canPop;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybaordActionInPropertyBase:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybaordActionInPropertyBase:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self textDeisgnViews];
}

- (void)doneAction{
    if (self.callback) {
        self.callback(self, _textView.text);
    }
}

- (void)textDeisgnViews{
    self.title = @"请输入";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybaordActionInPropertyBase:) name:UIKeyboardWillShowNotification object:nil];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = bbi;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, _fs_statusAndNavigatorHeight(), UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - _fs_statusAndNavigatorHeight() - _fs_tabbarBottomMoreHeight() - 300)];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_textView];
    if (_text) {
        _textView.text = _text;
    }

    [_textView becomeFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_canPop = YES;
    });
}

- (void)keybaordActionInPropertyBase:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _textView.height = UIScreen.mainScreen.bounds.size.height - _fs_statusAndNavigatorHeight() - keyboardSize.height;
}

- (BOOL)navigationShouldPopOnBackButton{
    if (_canPop) {
        return YES;
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return NO;
    }
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
