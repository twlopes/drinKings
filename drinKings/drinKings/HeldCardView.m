//
//  HeldCardView.m
//  drinKings
//
//  Created by Tristan Lopes on 24/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "HeldCardView.h"
#import "CardsHelper.h"

@implementation HeldCardView

@synthesize card=_card;

- (id)initWithFrame:(CGRect)frame andGameCard:(GameCard*)gameCard
{
    DLog(@"~");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _card = gameCard;
        
        if(_lblRule==nil){
            _lblRule = [[UILabel alloc] init];
        }
        _lblRule.frame = CGRectMake(0, 5, self.frame.size.width, 30);
        _lblRule.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lblRule.text = _card.card.rule.name;
        _lblRule.backgroundColor = [UIColor clearColor];
        _lblRule.textColor = [UIColor blackColor];
        _lblRule.textAlignment = UITextAlignmentCenter;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _lblRule.font = [UIFont systemFontOfSize:16.0];
        }else{
            _lblRule.font = [UIFont systemFontOfSize:16.0];
        }
        
        [self addSubview:_lblRule];
        
        float cardHeight = self.frame.size.height - 35 - 15;
        float cardWidth = cardHeight * kCardRatio;
        
        
        if(_ivCard==nil){
            _ivCard = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - cardWidth/2, 40, cardWidth, cardHeight)];
        }
        
        [_ivCard setImage:[CardsHelper imageForCard:_card.card]];
        [self addSubview:_ivCard];
    }
    return self;
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
