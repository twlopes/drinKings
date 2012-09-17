//
//  AboutViewController.m
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    
    self.title = @"About";
}

- (void)viewWillAppear:(BOOL)animated{
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    if(_wv==nil){
        _wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        
        for(UIView *wview in [[[_wv subviews] objectAtIndex:0] subviews]) {
            if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
        }
        
        NSString *css = [NSString stringWithFormat:@"\
                         html { -webkit-text-size-adjust: none; }\
                         body {font-family: \"%@\"; font-size: %@; color:#fff}\
                         img, embed, object, video, div, p, span, table, iframe{max-width:100%%; height:auto !important;}",  @"helvetica", [NSNumber numberWithInt:16]];
        
        
        
        NSString *html = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">%@</style></head><body><h2 style='text-align:center;'>Origin</h2><p>Of mysterious origin, drinKings was said to have been developed by the Earl of Sandwich to accompany his alcoholism. Other swear it was raised by fire-breathing candied dragons to enslave all that threatened their treasure. All we know for sure is that drinKings is here and developed by some Hot Candy.</p></body></html>", css];
        
        _wv.backgroundColor = [UIColor clearColor];
        [_wv setOpaque:NO];
        [_wv loadHTMLString:html baseURL:nil];
        [self.view addSubview:_wv];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
