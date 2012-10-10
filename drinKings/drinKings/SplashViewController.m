//
//  SplashViewController.m
//  drinKings
//
//  Created by Tristan Lopes on 26/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "SplashViewController.h"
#import "MainViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.title = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self startSequence];
}

#pragma mark -
#pragma mark splash

- (void)startSequence{
    [self displayGame];
}

- (void)displayGame{
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height){
            w = [UIScreen mainScreen].bounds.size.height;
            h = [UIScreen mainScreen].bounds.size.width;
        }else{
            w = [UIScreen mainScreen].bounds.size.width;
            h = [UIScreen mainScreen].bounds.size.height;
        }
    }
    
    // start timer
    _timerGame = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(endGame) userInfo:nil repeats:NO];
    
    // get splash up and running, no need for transition since it should already be displayed from loading
    _btnSplashGame = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _btnSplashGame.frame = CGRectMake(0, -20, w, h+20);
    }else{
        _btnSplashGame.frame = CGRectMake(0, -20, w, h);
    }
    
    _btnSplashGame.adjustsImageWhenHighlighted=NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if(h>500){
            [_btnSplashGame setBackgroundImage:[UIImage imageNamed:@"Default-568h"] forState:UIControlStateNormal];
        }else{
            [_btnSplashGame setBackgroundImage:[UIImage imageNamed:@"Default"] forState:UIControlStateNormal];
        }
    }else{
        [_btnSplashGame setBackgroundImage:[UIImage imageNamed:@"Default-Landscape~ipad"] forState:UIControlStateNormal];
    }
    [_btnSplashGame addTarget:self action:@selector(endGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSplashGame];
}

- (void)endGame{
    // destroy game timer
    [_timerGame invalidate];
    _timerGame=nil;
    
    //start animation for fade out
    [UIView animateWithDuration:0.7 delay:0.3 options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         DLog(@"fade out game");
                         
                         _btnSplashGame.alpha=0;
                     }
                     completion:^(BOOL finished) {
                         DLog(@"all done");
                         [_btnSplashGame removeFromSuperview];
                         [self displayCompany];
                     }];
    
}

- (void)displayCompany{
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height){
            w = [UIScreen mainScreen].bounds.size.height;
            h = [UIScreen mainScreen].bounds.size.width;
        }else{
            w = [UIScreen mainScreen].bounds.size.width;
            h = [UIScreen mainScreen].bounds.size.height;
        }
    }
    
    // fade company splash in
    _btnSplashCompany = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSplashCompany.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _btnSplashCompany.adjustsImageWhenHighlighted=NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if(h>500){
            DLog(@"big company");
            [_btnSplashCompany setBackgroundImage:[UIImage imageNamed:@"Company-iphone-568h"] forState:UIControlStateNormal];
        }else{
            [_btnSplashCompany setBackgroundImage:[UIImage imageNamed:@"Company-iphone"] forState:UIControlStateNormal];
        }
        
        [_btnSplashCompany setBackgroundImage:[UIImage imageNamed:@"Company-iphone"] forState:UIControlStateNormal];
    }else{
        [_btnSplashCompany setBackgroundImage:[UIImage imageNamed:@"Company-ipad"] forState:UIControlStateNormal];
    }
    [_btnSplashCompany addTarget:self action:@selector(endCompany) forControlEvents:UIControlEventTouchUpInside];
    _btnSplashCompany.alpha=0;
    [self.view addSubview:_btnSplashCompany];
    
    [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         DLog(@"fade in company");
                         
                         _btnSplashCompany.alpha=1;
                     }
                     completion:^(BOOL finished) {
                         DLog(@"all done");
                         // start timer
                         _timerCompany = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(endCompany) userInfo:nil repeats:NO];
                     }];
}

- (void)endCompany{
    // destroy game timer
    [_timerCompany invalidate];
    _timerCompany=nil;
    
    //start animation for fade out
    [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         DLog(@"fade out company");
                         
                         _btnSplashCompany.alpha=0;
                     }
                     completion:^(BOOL finished) {
                         DLog(@"all done");
                         [_btnSplashCompany removeFromSuperview];
                         
                         MainViewController *main = [[MainViewController alloc] init];
                         [self.navigationController pushViewController:main animated:NO];
                     }];
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskLandscape;
    else  /* iphone */
        return UIInterfaceOrientationMaskPortrait;
}

@end
