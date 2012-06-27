//
//  GameBoardViewController.h
//  drinkingcards
//
//  Created by Tristan Lopes on 22/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "Card.h"
#import "Game.h"

@interface GameBoardViewController : UIViewController {
    
    
    NSMutableArray *_players;
    
    // game items
    Game *_currentGame;
    Player *_currentPlayer;
    Card *_currentCard;
    
    // gui
    // cheap gui
    UIView *_toolbar;
    NSMutableArray *_arrayPlayerViews;
    
    UIImageView *_ivPlayer;
    UILabel *_lblPlayerTurn;
    UIButton *_btnQuit;
    
    UIImageView *_ivBG;
    UIImageView *_ivCurrentCard;
    
    // rule stuff
    UIImageView *_bgRule;
    UILabel *_lblRuleTitle;
    UILabel *_lblRuleDesc;
    UIButton *_btnFade;
    
    bool _turnAllowed;
}

@property (nonatomic, retain) NSMutableArray *players;

@end
