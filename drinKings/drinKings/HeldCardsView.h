//
//  HeldCardsView.h
//  drinKings
//
//  Created by Tristan Lopes on 30/06/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "GamePlayer.h"
#import "PageControl.h"
#import "GradientButton.h"

@interface HeldCardsView : UIView <PageControlDelegate, UIScrollViewDelegate> {
    __weak id _delegate;
    
    GamePlayer *_gamePlayer;
    Game *_game;
    NSArray *_cards;
    
    UIButton *_backgroundView; // covers whole screen
    UIView *_cardBackgroundView; // what everything else displays on
    
    UIButton *_btnClose;
    GradientButton *_btnQuit;
    
    // player
    UIView *_playerBackgroundView;
    UIImageView *_ivPlayer;
    UILabel *_lblPlayer;
    
    // cards
    UIScrollView *_svCards;
    PageControl *_svPageControl;
    GradientButton *_btnPlay;
    
    // none
    UILabel *_lblNone;
    GradientButton *_btnNone;
}

@property (weak) id delegate;
@property (nonatomic, retain) GamePlayer *gamePlayer;
@property (nonatomic, retain) Game *game;

@end
