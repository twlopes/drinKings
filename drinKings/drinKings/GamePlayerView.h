//
//  GamePlayerView.h
//  drinkingcards
//
//  Created by Tristan Lopes on 17/06/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamePlayer.h"

@interface GamePlayerView : UIView {
    GamePlayer *_gamePlayer;
    
    UIImageView *_ivPlayer;
    UILabel *_lblPlayer;
    UIView *_backgroundView;
    UIButton *_btnPlayer;
}

@property (nonatomic, retain) GamePlayer *gamePlayer;
@property (nonatomic, retain) UIImageView *ivPlayer;
@property (nonatomic, retain) UILabel *lblPlayer;
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIButton *btnPlayer;

- (void)updateCards;

@end
