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
//    CGRect bouds = [[UIScreen mainScreen]applicationFrame];
//    UIWebView* webView = [[UIWebView alloc]initWithFrame:bouds];
//    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//    
//    [self.view addSubview:webView];
//    NSURL* url = [NSURL URLWithString:@"http://www.baidu.com"];//创建URL
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//    [webView loadRequest:request];//加载
    

    
    [[ConanAccessRight sharedInstance]ConanAccessRightBluetoothPeripheral:^(BOOL Authorize) {
        if (Authorize) {
            NSLog(@"已经授权");
        } else {
            NSLog(@"未授权");
        }
    }];

}

-(void)desc
{
//    健康分享权限ConanAccessRightHealthShare
//    健康更新权限ConanAccessRightHealthUpdate
//    智能家居权限ConanAccessRightHomeKit
//    音乐权限ConanAccessRightMusic
//    Siri权限ConanAccessRightSiri
//    语音转文字权限ConanAccessRightSpeechRecognition
//    电视供应商权限ConanAccessRightTVProvider
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
