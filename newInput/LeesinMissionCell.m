//
//  PIEMyMissionCell.m
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/6/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "LeesinMissionCell.h"
#import "LeesinCheckmarkView.h"

@implementation LeesinMissionCell
-(void)awakeFromNib {
    [self pie_commonInit];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self pie_commonInit];
    }
    return self;
}

- (void)pie_commonInit {
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
}

-(void)setSelected:(BOOL)selected {
    if (_selected == selected) {
        return;
    }
    _selected = selected;
    _checkmark.selected = selected;
}

@end
