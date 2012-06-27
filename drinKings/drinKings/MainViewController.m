//
//  twlViewController.m
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "MainViewController.h"
#import "PlayerChoiceViewController.h"

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
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    UIButton *btnPlay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    btnPlay.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    btnPlay.frame = CGRectMake(20, h-(h/10)-(h/20), w-40, h/10);
    [btnPlay addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPlay];
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
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Buttons

- (void)play{
    PlayerChoiceViewController *pcvc = [[PlayerChoiceViewController alloc] init];
    
    [self.navigationController pushViewController:pcvc animated:YES];
    
    //[pcvc release];
}

@end
