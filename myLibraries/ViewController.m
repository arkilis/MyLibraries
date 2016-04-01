//
//  ViewController.m
//  testProtocol
//
//  Created by Ben Liu on 14/02/2016.
//  Copyright © 2016 Ben Liu. All rights reserved.
//

#import "ViewController.h"
#import "BLHyperTextField.h"
#import "BLImageButton.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    CGRect someRect1 = CGRectMake(20.0, 20.0, 100.0, 30.0);
    BLHyperTextField *bllink1= [[BLHyperTextField alloc] initWithFrame:someRect1];
    
    //[bllink setLink:@"Test" link:@"http://www.arkilis.me"];
    [bllink1 setLink:@"Test" link:@"http://www.arkilis.me" foregroundColor:[UIColor redColor] underline:NO];
    bllink1.delegate=(id)self;
    [self.view addSubview:bllink1];
    
    
    CGRect someRect2 = CGRectMake(20.0, 50.0, 200.0, 50.0);
    BLHyperTextField *bllink2= [[BLHyperTextField alloc] initWithFrame:someRect2];
    //UIFont *font= [UIFont fontWithName:@"Palatino-Roman" size:14.0];
    [bllink2 setLink:@"Test" link:@"http://www.arkilis.me" foregroundColor:[UIColor redColor] underline:YES fontName:@"Palatino-Roman" fontSize:44];
    bllink2.delegate= (id)self;
    [self.view addSubview:bllink2];
    
    CGRect rectBtn1 = CGRectMake(20.0, 100.0, 100.0, 30.0);
    BLImageButton *blib= [[BLImageButton alloc] initWithFrame:rectBtn1];
    [blib setLocalImageButton:@"Tick" localImage:@"ticks.png" url:@"http://www.arkilis.me"];
    [self.view addSubview:blib];
    
    
    CGRect rectBtn2 = CGRectMake(20.0, 140.0, 100.0, 30.0);
    BLImageButton *blib2= [[BLImageButton alloc] initWithFrame:rectBtn2];
    //[blib2 setURLImageButton:@"Online" imageURL:@"https://www.chiphell.com/uc_server/data/avatar/000/29/22/69_avatar_middle.jpg" url:@"http://www.arkilis.me"];
    //[blib2 setURLImageButton:@"Online" imageURL:@"https://www.planwallpaper.com/static/images/dragon-ball_1153759.jpg" url:@"http://www.arkilis.me"];
    [blib2 setURLImageButton:@"Online" imageURL:@"https://www.planwallpaper.com/static/images/dragon-ball_1153759.jpg" url:@"http://www.arkilis.me" cache:YES];
    [self.view addSubview:blib2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"trigger delegated methods.YYYY");
    return NO;
}

@end
