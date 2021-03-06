//
//  GamePlayerView.m
//  drinkingcards
//
//  Created by Tristan Lopes on 17/06/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "GamePlayerView.h"
#import "CardsHelper.h"

@implementation GamePlayerView

@synthesize ivPlayer=_ivPlayer, lblPlayer=_lblPlayer, backgroundView=_backgroundView, gamePlayer=_gamePlayer, btnPlayer=_btnPlayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        float w = frame.size.width;
        float h = frame.size.height;
        
        if(_backgroundView==nil){
            _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(2.5, 2.5, w-5, h-5)];
        }
        _backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgroundView];
        
        float imgWidth = MIN(h, w);
        
        if(_ivPlayer==nil){
            _ivPlayer = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, imgWidth-10, h-10)];
        }
        //[_ivPlayer setImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
        _ivPlayer.backgroundColor = [UIColor grayColor];
        _ivPlayer.contentMode = UIViewContentModeScaleAspectFill;
        _ivPlayer.layer.masksToBounds=YES;
        [self addSubview:_ivPlayer];
        
        if(_lblPlayer==nil){
            _lblPlayer = [[UILabel alloc] init];
        }
        _lblPlayer.frame = CGRectMake(h+5, 0, MAX(0, w-(imgWidth+5+2)), h);
        _lblPlayer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lblPlayer.text = @"Player Turn";
        _lblPlayer.backgroundColor = [UIColor clearColor];
        _lblPlayer.textColor = [UIColor whiteColor];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _lblPlayer.font = [UIFont systemFontOfSize:12.0];
        }else{
            _lblPlayer.font = [UIFont systemFontOfSize:16.0];
        }
        
        [self addSubview:_lblPlayer];
        
        float heldW = (imgWidth-10)/3;
        float heldH = heldW / kCardRatio;
        
        if(_ivHeldCards==nil){
            _ivHeldCards = [[UIImageView alloc] initWithFrame:CGRectMake((imgWidth-10)-heldW, (imgWidth-10)-heldH, heldW, heldH)];
        }
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [_ivHeldCards setImage:[UIImage imageNamed:@"back-iphone.png"]];
        }else{
            [_ivHeldCards setImage:[UIImage imageNamed:@"back-ipad.png"]];
        }
        
        CGAffineTransform transform = CGAffineTransformMakeRotation([[NSNumber numberWithFloat:(2.0f * ((float)rand() / (float)RAND_MAX) - 1.0f)*0.5] floatValue]);
        _ivHeldCards.transform = transform;
        
        [self addSubview:_ivHeldCards];
        
        if(_btnPlayer==nil){
            _btnPlayer = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        _btnPlayer.backgroundColor = [UIColor clearColor];
        _btnPlayer.frame = CGRectMake(0, 0, w, h);
        _btnPlayer.showsTouchWhenHighlighted = YES;
        [self addSubview:_btnPlayer];
        
    }
    return self;
}

- (void)updateCards{
    
}

- (void)hasCards:(bool)result{
    if(result){
        CGAffineTransform transform = CGAffineTransformMakeRotation([[NSNumber numberWithFloat:(2.0f * ((float)rand() / (float)RAND_MAX) - 1.0f)*0.5] floatValue]);
        _ivHeldCards.transform = transform;
        _ivHeldCards.hidden=NO;
    }else{
        _ivHeldCards.hidden=YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
