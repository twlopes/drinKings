//
//  HeldCardView.h
//  drinKings
//
//  Created by Tristan Lopes on 24/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCard.h"
#import "Card.h"
#import "Rule.h"

@interface HeldCardView : UIView {
    GameCard *_card;
    
    UILabel *_lblRule;
    UIButton *_btnRuleInfo;
    UIImageView *_ivCard;
}

@property (nonatomic, retain) GameCard *card;

- (id)initWithFrame:(CGRect)frame andGameCard:(GameCard*)gameCard;

@end
