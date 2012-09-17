//
//  HelpViewController.m
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
    
    self.title = @"Help";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
                         * {\
                            -webkit-touch-callout: none;\
                            -webkit-user-select: none;\
                         }\
                         img, embed, object, video, div, p, span, table, iframe{max-width:100%%; height:auto !important;}",  @"helvetica", [NSNumber numberWithInt:16]];
        

        
        NSString *html = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">%@</style></head><body><h2 style='text-align:center;'>drinKings</h2><p>drinKings is based on the drinking game called 'Kings' which also known as 'Circle of Death', 'Kings Cup' and many others. It is very simple and the rules can vary with each game, but the basic premise is:</p><ul><li>Players sit around the pile of cards</li><li>Each player takes turns at drawing cards from the pile</li><li>Each card has a rule which players must obey</li></ul><h2 style='text-align:center;'>Deck Editor</h2><p>In drinKing's there is a deck editor which allows the creation of different 'decks' and also the creating and assigning of rules to every card in the deck. When you are looking at the cards in a deck, just select the cards you want to change, touch 'Rules', select a rule and it will be changed.</p></body></html>", css];
        
        _wv.backgroundColor = [UIColor clearColor];
        [_wv setOpaque:NO];
        [_wv loadHTMLString:html baseURL:nil];
        [self.view addSubview:_wv];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
