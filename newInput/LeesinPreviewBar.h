//
//  LeesinPreviewToolBar.h
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/7/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LeesinPreviewBarType) {
    LeesinPreviewBarTypeAsk,
    LeesinPreviewBarTypeReply,
};
@interface LeesinPreviewBar : UIView

@property (nonatomic, assign) LeesinPreviewBarType type;
@property (nonatomic, strong) UIImageView *previewImageView1;
@property (nonatomic, strong) UIImageView *previewImageView2;

@end
