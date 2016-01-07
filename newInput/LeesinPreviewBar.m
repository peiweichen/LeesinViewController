//
//  LeesinPreviewToolBar.m
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/7/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "LeesinPreviewBar.h"
#import "Masonry.h"

@implementation LeesinPreviewBar


- (id)init
{
    if (self = [super init]) {
        [self pie_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self pie_commonInit];
    }
    return self;
}


- (void)pie_commonInit
{
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self addSubview:self.previewImageView1];
    [self addSubview:self.previewImageView2];
    
    [self pie_setupViewConstraints];

}
- (void) pie_setupViewConstraints {
    //    CGSize buttonSize1 = [self pie_appropriateButtonSize:self.button_album];
    //    CGSize buttonSize2 = [self pie_appropriateButtonSize:self.button_shoot];
    //    CGSize buttonSize3 = [self pie_appropriateButtonSize:self.button_confirm];
    
    [self.previewImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(6);
        make.bottom.equalTo(self).with.offset(-7);
        make.leading.equalTo(self).with.offset(9);
        make.width.equalTo(self.previewImageView1.mas_height);
    }];
    [self.previewImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(6);
        make.bottom.equalTo(self).with.offset(-7);
        make.leading.equalTo(self.previewImageView1).with.offset(6);
        make.width.equalTo(self.previewImageView1.mas_height);
    }];
}
-(UIImageView *)previewImageView1 {
    if (!_previewImageView1) {
        _previewImageView1 = [UIImageView new];
        _previewImageView1.contentMode = UIViewContentModeScaleAspectFill;
        _previewImageView1.clipsToBounds = YES;
    }
    return _previewImageView1;
}

-(UIImageView *)previewImageView2 {
    if (!_previewImageView2) {
        _previewImageView2 = [UIImageView new];
        _previewImageView2.contentMode = UIViewContentModeScaleAspectFill;
        _previewImageView2.clipsToBounds = YES;
    }
    return _previewImageView2;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self addBottomLine];
}

-(void)addBottomLine {
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    [self.layer addSublayer:border];
}

@end
