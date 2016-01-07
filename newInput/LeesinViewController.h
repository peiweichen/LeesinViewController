//
//  ViewController.h
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LeesinViewControllerType) {
    LeesinViewControllerTypeAsk = 0,
    LeesinViewControllerTypeReply,
};

@interface LeesinViewController : UIViewController

@property (nonatomic,assign)LeesinViewControllerType type;
@end

