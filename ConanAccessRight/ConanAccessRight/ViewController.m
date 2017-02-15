//
//  ViewController.m
//  ConanAccessRight
//
//  Created by Conan on 2017/2/15.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "ViewController.h"
#import "ConanAccessRight.h"
@interface ViewController ()
@property (nonatomic ,strong) UIButton *conanAccessRightBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.conanAccessRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.conanAccessRightBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.height/2-50, 100, 100);
    self.conanAccessRightBtn.backgroundColor = [UIColor yellowColor];
    [self.conanAccessRightBtn setTitle:@"授权" forState:UIControlStateNormal];
    [self.conanAccessRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.conanAccessRightBtn.layer.cornerRadius = 10;
    self.conanAccessRightBtn.layer.masksToBounds = YES;
    [self.conanAccessRightBtn addTarget:self action:@selector(accessRightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.conanAccessRightBtn];
    
}

-(void)accessRightBtnEvent
{
    [[ConanAccessRight sharedInstance]ConanAccessRightMotion:^(BOOL Authorize) {
        if (Authorize) {
            NSLog(@"已经授权");
        } else {
            NSLog(@"未授权");
        }
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
