//
//  twlViewController.m
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "MainViewController.h"
#import "PlayerChoiceViewController.h"
#import "DecksViewController.h"
#import "HelpViewController.h"
#import "AboutViewController.h"

@implementation MainViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    return;
    
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        if (self.view.frame.size.width < self.view.frame.size.height){
            w = self.view.frame.size.height;
            h = self.view.frame.size.width;
        }else{
            w = self.view.frame.size.width;
            h = self.view.frame.size.height;
        }
    }
    
    DLog(@"width: %f height: %f", w, h);
    
    UIImageView *ivBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [ivBG setImage:[UIImage imageNamed:@"Default"]];
    }else{
        [ivBG setImage:[UIImage imageNamed:@"Default-Landscape~ipad"]];
    }
    [self.view addSubview:ivBG];
    
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        float temp = w;
        w = h;
        h = temp;
    }*/
    
    GradientButton *btnAbout = [GradientButton buttonWithType:UIButtonTypeCustom];
    [btnAbout useWhiteActionSheetStyle];
    [btnAbout setTitle:@"About" forState:UIControlStateNormal];
    btnAbout.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    btnAbout.frame = CGRectMake(10, 10, w-40, 40);
    [btnAbout addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAbout];
    
    GradientButton *btnHelp = [GradientButton buttonWithType:UIButtonTypeCustom];
    [btnHelp useWhiteActionSheetStyle];
    [btnHelp setTitle:@"How to Play" forState:UIControlStateNormal];
    btnHelp.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    btnHelp.frame = CGRectMake(w-10-120, 10, 120, 40);
    [btnHelp addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnHelp];
    
    
    GradientButton *btnDeck = [GradientButton buttonWithType:UIButtonTypeCustom];
    [btnDeck useAlertStyle];
    [btnDeck setTitle:@"Deck Editor" forState:UIControlStateNormal];
    btnDeck.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    btnDeck.frame = CGRectMake(w/2-60, 90, 120, 40);
    [btnDeck addTarget:self action:@selector(deck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDeck];
    
    
    GradientButton *btnPlay = [GradientButton buttonWithType:UIButtonTypeCustom];
    [btnPlay useSimpleOrangeStyle];
    [btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    btnPlay.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    //btnPlay.frame = CGRectMake(20, h-(h/6), w-40, h/7);
    DLog(@"width: %f height: %f", w, h);
    btnPlay.frame = CGRectMake(20, h, w-40, h/7);
    [btnPlay addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPlay];
    DLog(@"play width: %f height: %f", w-40, h/7);
    DLog(@"play width: %f height: %f originy %f", btnPlay.frame.size.width, btnPlay.frame.size.height, btnPlay.frame.origin.y);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    float w;
    float h;
    
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    /*}else{
        if (self.view.frame.size.width < self.view.frame.size.height){
            w = self.view.frame.size.height;
            h = self.view.frame.size.width;
        }else{
            w = self.view.frame.size.width;
            h = self.view.frame.size.height;
        }
    }*/
    
    DLog(@"width: %f height: %f", w, h);
    
    if(_ivBG==nil){
        DLog(@"`");
        _ivBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [_ivBG setImage:[UIImage imageNamed:@"Default.png"]];
        }else{
            [_ivBG setImage:[UIImage imageNamed:@"Default-Landscape~ipad.png"]];
        }
        [self.view addSubview:_ivBG];
    }
    
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
     float temp = w;
     w = h;
     h = temp;
     }*/
    
    if(_btnAbout==nil){
        _btnAbout = [GradientButton buttonWithType:UIButtonTypeCustom];

        [_btnAbout useWhiteActionSheetStyle];
        [_btnAbout setTitle:@"About" forState:UIControlStateNormal];
        _btnAbout.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        _btnAbout.frame = CGRectMake(10, 10, 120, h/10);
        [_btnAbout addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnAbout];
    }
    
    if(_btnHelp==nil){
        _btnHelp = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnHelp useWhiteActionSheetStyle];
        [_btnHelp setTitle:@"How to Play" forState:UIControlStateNormal];
        _btnHelp.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        _btnHelp.frame = CGRectMake(w-130, 10, 120, h/10);
        [_btnHelp addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnHelp];
    }
    
    
    if(_btnDeck==nil){
        _btnDeck = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnDeck useAlertStyle];
        [_btnDeck setTitle:@"Deck Editor" forState:UIControlStateNormal];
        _btnDeck.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        _btnDeck.frame = CGRectMake(20, h-(h/6)-(h/7), w-40, h/9);
        [_btnDeck addTarget:self action:@selector(deck) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _btnDeck.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        }else{
            _btnDeck.titleLabel.font = [UIFont systemFontOfSize:36.0f];
        }
        
        [self.view addSubview:_btnDeck];
    }
    
    if(_btnPlay==nil){
        _btnPlay = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnPlay useSimpleOrangeStyle];
        [_btnPlay setTitle:@"Play" forState:UIControlStateNormal];
        _btnPlay.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        _btnPlay.frame = CGRectMake(20, h-(h/6), w-40, h/7);
        [_btnPlay addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _btnPlay.titleLabel.font = [UIFont boldSystemFontOfSize:26.0f];
        }else{
            _btnPlay.titleLabel.font = [UIFont boldSystemFontOfSize:42.0f];
        }
        
        [self.view addSubview:_btnPlay];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    }
}

#pragma mark - Buttons

- (void)play{
    PlayerChoiceViewController *pcvc = [[PlayerChoiceViewController alloc] init];
    
    [self.navigationController pushViewController:pcvc animated:YES];
    
    //[pcvc release];
}

- (void)help{
    HelpViewController *vc = [[HelpViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    //[pcvc release];
}

- (void)about{
    AboutViewController *vc = [[AboutViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];

    
    //[pcvc release];
}

- (void)deck{
    DecksViewController *vc = [[DecksViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    //[pcvc release];
}

@end
