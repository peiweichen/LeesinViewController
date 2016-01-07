//
//  ViewController.m
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/7/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "ViewController.h"
#import "LeesinViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton* BUTTON1 = [UIButton new];
    [BUTTON1 setTitle:@"求p" forState:UIControlStateNormal];
    [BUTTON1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton* BUTTON2 = [UIButton new];
    [BUTTON2 setTitle:@"作品" forState:UIControlStateNormal];
    [BUTTON2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    BUTTON1.frame = CGRectMake(20, 100, 100, 40);
    BUTTON2.frame = CGRectMake(20, 200, 100, 40);
    [self.view addSubview:BUTTON1];
    [self.view addSubview:BUTTON2];
    
    [BUTTON1 addTarget:self action:@selector(tap1) forControlEvents:UIControlEventTouchUpInside];
    [BUTTON2 addTarget:self action:@selector(tap2) forControlEvents:UIControlEventTouchUpInside];

    self.view.backgroundColor = [UIColor whiteColor];
    
 
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tap1];
    });
}
- (void)tap1 {
    LeesinViewController* vc = [LeesinViewController new];
    vc.type = LeesinViewControllerTypeAsk;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)tap2 {
    LeesinViewController* vc = [LeesinViewController new];
    vc.type = LeesinViewControllerTypeReply;

    [self presentViewController:vc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
