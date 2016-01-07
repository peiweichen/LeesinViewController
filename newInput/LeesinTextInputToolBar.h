//
//  PIETextInputbar.h
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeesinTextView;
typedef NS_ENUM(NSUInteger, LeesinTextInputBarButtonState) {
    LeesinTextInputBarButtonStateMission,
    LeesinTextInputBarButtonStatePhoto
};
typedef NS_ENUM(NSUInteger, LeesinTextInputToolBarType) {
    LeesinTextInputToolBarTypeAsk,
    LeesinTextInputToolBarTypeReply
};

@interface LeesinTextInputToolBar : UIToolbar

@property (nonatomic, strong) LeesinTextView *textView;
@property (nonatomic, strong) UIButton *leftButton1;
@property (nonatomic, strong) UIButton *leftButton2;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) LeesinTextInputToolBarType type;

@property (nonatomic, assign) LeesinTextInputBarButtonState state;
@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, readonly) CGFloat minimumInputbarHeight;
@property (nonatomic, readonly) CGFloat appropriateHeight;


- (instancetype)initWithTextViewClass:(Class)textViewClass;
- (void)pie_hideLeftButton1;
@end
