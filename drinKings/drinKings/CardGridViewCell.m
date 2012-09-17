//
//  CardGridViewCell.m
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "CardGridViewCell.h"
#import "CardsHelper.h"

@implementation CardGridViewCell

@synthesize ivCard=_ivCard, lblName=_lblName, isSelected=_isSelected, viewSelect=_viewSelect;

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
    
    _viewSelect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    _viewSelect.backgroundColor = [UIColor clearColor];
    _viewSelect.layer.cornerRadius=5.0f;
    [self.contentView addSubview:_viewSelect];
    
    float deckH = h-55;
    float deckW = deckH*kCardRatio;
    
    _ivCard = [[UIImageView alloc] initWithFrame:CGRectMake(w/2-deckW/2, 5, deckW, deckH)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [_ivCard setImage:[UIImage imageNamed:@"deck-iphone.png"]];
    }else{
        [_ivCard setImage:[UIImage imageNamed:@"deck-ipad.png"]];
    }
    _ivCard.layer.shadowColor = [UIColor blackColor].CGColor;
    _ivCard.layer.shadowOpacity = 0.65;
    _ivCard.layer.shadowOffset = CGSizeMake(0,4);
    _ivCard.layer.shouldRasterize=YES;
    [self.contentView addSubview:_ivCard];
    
    if(_lblName==nil){
        _lblName = [[UILabel alloc] init];
    }
    _lblName.frame = CGRectMake(10, h-55, w-20, 55);
    _lblName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _lblName.text = @"Deck";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [_lblName setFont:[UIFont systemFontOfSize:14.0f]];
    }else{
        [_lblName setFont:[UIFont systemFontOfSize:20.0f]];
    }
    _lblName.textColor = [UIColor whiteColor];
    _lblName.textAlignment = UITextAlignmentCenter;
    _lblName.numberOfLines = 2;
    _lblName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_lblName];
    
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
