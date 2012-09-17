//
//  DeckGridViewCell.m
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "DeckGridViewCell.h"
#import "CardsHelper.h"

@implementation DeckGridViewCell

@synthesize ivDeck=_ivDeck, lblName=_lblName, isSelected=_isSelected, btnDelete=_btnDelete;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return ( nil );
    
    DLog(@"frame %f %f", frame.size.width, frame.size.height);
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    float w = frame.size.width;
    float h = frame.size.height;
    
    float deckH = h-40;
    float deckW = deckH*kCardRatio;
    
    _ivDeck = [[UIImageView alloc] initWithFrame:CGRectMake(w/2-deckW/2, 0, deckW, deckH)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [_ivDeck setImage:[UIImage imageNamed:@"deck-iphone.png"]];
    }else{
        [_ivDeck setImage:[UIImage imageNamed:@"deck-ipad.png"]];
    }
    _ivDeck.layer.shadowColor = [UIColor blackColor].CGColor;
    _ivDeck.layer.shadowOpacity = 0.65;
    _ivDeck.layer.shadowOffset = CGSizeMake(0,4);
    _ivDeck.layer.shouldRasterize=YES;
    [self.contentView addSubview:_ivDeck];
    
    if(_lblName==nil){
        _lblName = [[UILabel alloc] init];
    }
    _lblName.frame = CGRectMake(10, h-40, w-20, 40);
    _lblName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _lblName.text = @"Deck";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [_lblName setFont:[UIFont systemFontOfSize:14.0f]];
    }else{
        [_lblName setFont:[UIFont systemFontOfSize:20.0f]];
    }
    //_lblName.backgroundColor = [UIColor yellowColor];
    _lblName.textColor = [UIColor whiteColor];
    _lblName.textAlignment = UITextAlignmentCenter;
    _lblName.numberOfLines = 2;
    _lblName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_lblName];
    
    _btnDelete = [GradientButton buttonWithType:UIButtonTypeCustom];
    [_btnDelete useRedDeleteStyle];
    [_btnDelete setTitle:@"X" forState:UIControlStateNormal];
    _btnDelete.frame = CGRectMake(frame.size.width-30, -5, 30, 30);
    _btnDelete.contentEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    _btnDelete.hidden=YES;
    _btnDelete.layer.shadowColor = [UIColor blackColor].CGColor;
    _btnDelete.layer.shadowOpacity = 0.65;
    _btnDelete.layer.shadowOffset = CGSizeMake(0,4);
    [self.contentView addSubview:_btnDelete];
    
    return ( self );
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
