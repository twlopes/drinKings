//
//  HeldCardsView.h
//  drinKings
//
//  Created by Tristan Lopes on 30/06/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamePlayer.h"
#import "PageControl.h"

@interface HeldCardsView : UIView {
    __weak id _delegate;
    
    GamePlayer *_gamePlayer;
    
    UIButton *_backgroundView; // covers whole screen
    UIView *_cardBackgroundView; // what everything else displays on
    
    UIButton *_btnClose;
    
    // player
    UIView *_playerBackgroundView;
    UIImageView *_ivPlayer;
    UILabel *_lblPlayer;
    
    // cards
    UILabel *_lblRule;
    UIButton *_btnRuleInfo;
    UIScrollView *_svCards;
    PageControl *_svPageControl;
    UIButton *_btnPlay;
}

@property (weak) id delegate;
@property (nonatomic, retain) GamePlayer *gamePlayer;

@end
