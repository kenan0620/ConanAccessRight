//
//  SecViewController.m
//  ConanAccessRight
//
//  Created by Conan on 2017/2/24.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "SecViewController.h"
#import "ConanAccessRight.h"
#import <Speech/Speech.h>
@import HomeKit;
@import SafariServices;
@interface SecViewController ()<SFSpeechRecognitionTaskDelegate>


@property (nonatomic ,strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic ,strong) SFSpeechRecognizer      *speechRecognizer;
@property (nonatomic ,strong) UILabel                 *recognizerLabel;


@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"SecViewController";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    
    [[ConanAccessRight sharedInstance] ConanAccessRightSpeechRecognition:^(BOOL Authorize) {
        if (Authorize)
        {
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
