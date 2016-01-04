//
//  ViewController.m
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "PIETextInputbar.h"

@interface ViewController ()

@property (nonatomic, strong) MASConstraint *masInputbarHeght;
@property (nonatomic, strong) MASConstraint *masInputbarBottom;

@property (nonatomic, strong) PIETextInputbar* bar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _bar = [PIETextInputbar new];
    [self.view addSubview:_bar];
    [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
        _masInputbarHeght  = make.height.equalTo(@(_bar.appropriateHeight));
        _masInputbarBottom = make.bottom.equalTo(self.view);
        make.leading.equalTo(self.view).with.offset(0);
        make.trailing.equalTo(self.view);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tupai_didChangeTextViewText:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pie_willShowOrHideKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pie_willShowOrHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pie_didShowOrHideKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pie_didShowOrHideKeyboard:) name:UIKeyboardDidHideNotification object:nil];

}

- (void)tupai_didChangeTextViewText:(id)sender {

    if (![[sender object] isEqual: _bar.textView]) {
        return;
    }
    if (_bar.frame.size.height != _bar.appropriateHeight) {
        [_masInputbarHeght setOffset:_bar.appropriateHeight];
    }
}

- (void) pie_willShowOrHideKeyboard:(NSNotification*)notification {
    [_masInputbarBottom setOffset:-[self pie_appropriateKeyboardHeightFromNotification:notification]];
}
- (void) pie_didShowOrHideKeyboard:(NSNotification*)notification {
    
}


- (CGFloat)pie_appropriateKeyboardHeightFromNotification:(NSNotification *)notification
{
    
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    return [self pie_appropriateKeyboardHeightFromRect:keyboardRect];
}
- (CGFloat)pie_appropriateKeyboardHeightFromRect:(CGRect)rect
{
    CGRect keyboardRect = [self.view convertRect:rect fromView:nil];
    
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat keyboardMinY = CGRectGetMinY(keyboardRect);
    
    CGFloat keyboardHeight = MAX(0.0, viewHeight - keyboardMinY);
    
    return keyboardHeight;
}


@end
