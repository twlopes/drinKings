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
#import "CardsHelper.h"

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
    
    _firstLoad=YES;
    
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
        
        /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [_ivBG setImage:[UIImage imageNamed:@"Default.png"]];
        }else{
            [_ivBG setImage:[UIImage imageNamed:@"Default-Landscape~ipad.png"]];
        }*/
        [_ivBG setImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
        [self.view addSubview:_ivBG];
    }
    
    if(_ivLogo==nil){
        DLog(@"`");
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _ivLogo = [[UIImageView alloc] initWithFrame:CGRectMake(w/2-293/2, 125, 293, 74)];
            [_ivLogo setImage:[UIImage imageNamed:@"dlogo-iphone.png"]];
        }else{
            _ivLogo = [[UIImageView alloc] initWithFrame:CGRectMake(w/2-698/2, 120, 698, 172)];
            [_ivLogo setImage:[UIImage imageNamed:@"dlogo-ipad.png"]];
        }
        [self.view addSubview:_ivLogo];
    }
    
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
     float temp = w;
     w = h;
     h = temp;
     }*/
    
    /*if(_btnAbout==nil){
        _btnAbout = [GradientButton buttonWithType:UIButtonTypeCustom];

        [_btnAbout useWhiteActionSheetStyle];
        [_btnAbout setTitle:@"About" forState:UIControlStateNormal];
        _btnAbout.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        _btnAbout.frame = CGRectMake(10, 10, 120, h/10);
        [_btnAbout addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnAbout];
    }*/
    
    if(_btnHelp==nil){
        _btnHelp = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnHelp useWhiteActionSheetStyle];
        [_btnHelp setTitle:@"Help" forState:UIControlStateNormal];
        _btnHelp.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        _btnHelp.frame = CGRectMake(w-130, 10, 120, h/10);
        [_btnHelp addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnHelp];
    }
    
    float cardW;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        cardW = w/2.5;
    }else{
        cardW = w/4;
    }
    
    
    if(_btnDeck==nil){
        _btnDeck = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDeck setTitle:@"Deck\nEditor" forState:UIControlStateNormal];
        _btnDeck.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        _btnDeck.frame = CGRectMake(20, h-cardW/kCardRatio-20, cardW, cardW/kCardRatio);
        [_btnDeck addTarget:self action:@selector(deck) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [_btnDeck setBackgroundImage:[UIImage imageNamed:@"deck-iphone.png"] forState:UIControlStateNormal];
        }else{
            [_btnDeck setBackgroundImage:[UIImage imageNamed:@"deck-ipad.png"] forState:UIControlStateNormal];
        }
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _btnDeck.titleLabel.font = [UIFont boldSystemFontOfSize:26.0f];
        }else{
            _btnDeck.titleLabel.font = [UIFont boldSystemFontOfSize:54.0f];
        }
        _btnDeck.titleLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _btnDeck.titleLabel.layer.shadowRadius = 10.0f;
        _btnDeck.titleLabel.layer.shadowOpacity = 1.0;
        _btnDeck.titleLabel.layer.shadowOffset = CGSizeZero;
        _btnDeck.titleLabel.layer.masksToBounds = NO;
        
        /*_btnDeck.titleLabel.shadowColor = [UIColor blackColor];
        _btnDeck.titleLabel.shadowOffset = CGSizeMake(0, 4);
        _btnDeck.titleLabel.layer.shadowRadius = 8.0f;*/
        _btnDeck.titleLabel.numberOfLines=2;
        _btnDeck.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        _btnDeck.titleLabel.textAlignment = UITextAlignmentCenter;
        _btnDeck.layer.shadowColor = [UIColor blackColor].CGColor;
        _btnDeck.layer.shadowOpacity = 0.65;
        _btnDeck.layer.shadowOffset = CGSizeMake(0,4);
        [self.view addSubview:_btnDeck];
    }
    
    if(_btnPlay==nil){
        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_btnPlay useSimpleOrangeStyle];
        [_btnPlay setTitle:@"Play" forState:UIControlStateNormal];
        _btnPlay.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        _btnPlay.frame = CGRectMake(w-cardW-20, h-cardW/kCardRatio-20, cardW, cardW/kCardRatio);
        [_btnPlay addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [_btnPlay setBackgroundImage:[UIImage imageNamed:@"deck-iphone.png"] forState:UIControlStateNormal];
        }else{
            [_btnPlay setBackgroundImage:[UIImage imageNamed:@"deck-ipad.png"] forState:UIControlStateNormal];
        }
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _btnPlay.titleLabel.font = [UIFont boldSystemFontOfSize:30.0f];
        }else{
            _btnPlay.titleLabel.font = [UIFont boldSystemFontOfSize:60.0f];
        }
        _btnPlay.titleLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _btnPlay.titleLabel.layer.shadowRadius = 10.0f;
        _btnPlay.titleLabel.layer.shadowOpacity = 1.0;
        _btnPlay.titleLabel.layer.shadowOffset = CGSizeZero;
        _btnPlay.titleLabel.layer.masksToBounds = NO;
        
        /*_btnPlay.titleLabel.shadowColor = [UIColor blackColor];
        _btnPlay.titleLabel.shadowOffset = CGSizeMake(0, 4);*/
        _btnPlay.layer.shadowColor = [UIColor blackColor].CGColor;
        _btnPlay.layer.shadowOpacity = 0.65;
        _btnPlay.layer.shadowOffset = CGSizeMake(0,4);
        [self.view addSubview:_btnPlay];
    }
    
    if(_firstLoad){
        
        _viewCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _viewCover.backgroundColor=[UIColor blackColor];
        _viewCover.alpha=1;
        _viewCover.userInteractionEnabled=NO;
        [self.view addSubview:_viewCover];
        
        [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             _viewCover.alpha=0;
                         }
                         completion:^(BOOL finished) {
                             _viewCover.hidden=YES;
                         }];
        
        _firstLoad=NO;
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
    vc.contentSizeForViewInPopover = CGSizeMake(320, 480);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.contentSizeForViewInPopover = CGSizeMake(320, 480);
        
        if([UINavigationBar conformsToProtocol:@protocol(UIAppearance)]){
            [nav.navigationBar setBackgroundImage:nil
                                    forBarMetrics:UIBarMetricsDefault];
            [nav.navigationBar setBackgroundImage:nil
                                    forBarMetrics:UIBarMetricsLandscapePhone];
        }
        
        _popover = [[UIPopoverController alloc] initWithContentViewController:nav];
        _popover.delegate = (id<UIPopoverControllerDelegate>)self;
        [_popover presentPopoverFromRect:_btnHelp.frame
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionRight
                                animated:YES];
    }
    
    //[pcvc release];
}

- (void)about{
    AboutViewController *vc = [[AboutViewController alloc] init];
    vc.contentSizeForViewInPopover = CGSizeMake(320, 480);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.contentSizeForViewInPopover = CGSizeMake(320, 480);
        
        if([UINavigationBar conformsToProtocol:@protocol(UIAppearance)]){
            [nav.navigationBar setBackgroundImage:nil
                                    forBarMetrics:UIBarMetricsDefault];
            [nav.navigationBar setBackgroundImage:nil
                                    forBarMetrics:UIBarMetricsLandscapePhone];
        }
        
        _popover = [[UIPopoverController alloc] initWithContentViewController:nav];
        _popover.delegate = (id<UIPopoverControllerDelegate>)self;
        [_popover presentPopoverFromRect:_btnAbout.frame
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionLeft
                                animated:YES];
    }

    
    //[pcvc release];
}

- (void)deck{
    DecksViewController *vc = [[DecksViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    //[pcvc release];
}

-(NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskLandscape;
    else  /* iphone */
        return UIInterfaceOrientationMaskPortrait;
}

@end
