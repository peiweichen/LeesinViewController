//
//  PIETextInputbar.h
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIETextView;

@interface PIETextInputbar : UIToolbar

@property (nonatomic, strong) PIETextView *textView;
@property (nonatomic, strong) UIButton *leftButton1;
@property (nonatomic, strong) UIButton *leftButton2;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, readonly) CGFloat minimumInputbarHeight;
@property (nonatomic, readonly) CGFloat appropriateHeight;


- (instancetype)initWithTextViewClass:(Class)textViewClass;

@end
