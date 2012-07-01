//
//  HeldCardsView.m
//  drinKings
//
//  Created by Tristan Lopes on 30/06/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "HeldCardsView.h"
#import "CardsHelper.h"

@implementation HeldCardsView

@synthesize delegate=_delegate, gamePlayer=_gamePlayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
        _backgroundView.frame = [UIScreen mainScreen].bounds;
        [_backgroundView addTarget:self action:@selector(touchClose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundView];
        
        float w = _backgroundView.frame.size.width;
        float h = _backgroundView.frame.size.height;
        
        // work out card background height/width
        float bgCardHeight = h - 60; // 20 padding
        float bgCardWidth = bgCardHeight * kCardRatio;
        
        _cardBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(w/2 - bgCardWidth/2, 20, bgCardWidth, bgCardHeight)];
        _cardBackgroundView.backgroundColor = [UIColor whiteColor];
        _cardBackgroundView.userInteractionEnabled=NO;
        _cardBackgroundView.layer.cornerRadius = 8.0f;
        _cardBackgroundView.layer.masksToBounds=YES;
        [self addSubview:_cardBackgroundView];
        
        
        // Player
        
        _playerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cardBackgroundView.frame.size.width, h/15)];
        _playerBackgroundView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
        [_cardBackgroundView addSubview:_playerBackgroundView];
        
        if(_ivPlayer==nil){
            _ivPlayer = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, _playerBackgroundView.frame.size.height-10, _playerBackgroundView.frame.size.height-10)];
        }
        _ivPlayer.backgroundColor = [UIColor grayColor];
        _ivPlayer.contentMode = UIViewContentModeScaleAspectFill;
        _ivPlayer.layer.masksToBounds=YES;
        [_playerBackgroundView addSubview:_ivPlayer];
        
        if(_lblPlayer==nil){
            _lblPlayer = [[UILabel alloc] init];
        }
        _lblPlayer.frame = CGRectMake(_playerBackgroundView.frame.size.height+5, 0, _playerBackgroundView.frame.size.width-(_ivPlayer.frame.size.height+5), _playerBackgroundView.frame.size.height);
        _lblPlayer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lblPlayer.text = @"Held Cards";
        _lblPlayer.backgroundColor = [UIColor clearColor];
        _lblPlayer.textColor = [UIColor whiteColor];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _lblPlayer.font = [UIFont systemFontOfSize:12.0];
        }else{
            _lblPlayer.font = [UIFont systemFontOfSize:16.0];
        }
        
        [_playerBackgroundView addSubview:_lblPlayer];
        
        // Card
        
        float cardY = _playerBackgroundView.frame.size.height;
        float cardW = _cardBackgroundView.frame.size.width;
        
        if(_lblRule==nil){
            _lblRule = [[UILabel alloc] init];
        }
        _lblRule.frame = CGRectMake(0, cardY+5, cardW, 30);
        _lblRule.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lblRule.text = @"Rule";
        _lblRule.backgroundColor = [UIColor clearColor];
        _lblRule.textColor = [UIColor blackColor];
        _lblRule.textAlignment = UITextAlignmentCenter;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _lblRule.font = [UIFont systemFontOfSize:12.0];
        }else{
            _lblRule.font = [UIFont systemFontOfSize:16.0];
        }
        
        [_cardBackgroundView addSubview:_lblRule];
    }
    return self;
}

#pragma mark - Buttons

- (void)touchClose:(id)sender{
    DLog(@"~");
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

/*- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    DLog(@"~");
    
    for(UIView *subview in self.subviews)
    {
        UIView *view = [subview hitTest:[self convertPoint:point toView:subview] withEvent:event];
        
        if(view==_cardBackgroundView){
            return nil;
        }
        
        if(view) return view;
    }
    return [super hitTest:point withEvent:event];
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
