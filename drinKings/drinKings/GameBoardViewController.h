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
#import "GradientButton.h"
#import "GamePlayer.h"
#import "GameCard.h"
#import "PlayerImageView.h"
#import "Deck.h"

@interface GameBoardViewController : UIViewController {
    
    
    NSMutableArray *_players;
    
    // game items
    Deck *_currentDeck;
    Game *_currentGame;
    Player *_currentPlayer;
    GamePlayer *_currentGamePlayer;
    
    Card *_currentCard;
    GameCard *_currentGameCard;
    
    // gui
    // cheap gui
    UIView *_toolbar;
    NSMutableArray *_arrayPlayerViews;
    
    UIImageView *_ivPlayer;
    UILabel *_lblPlayerTurn;
    GradientButton *_btnQuit;
    
    UIImageView *_ivBG;
    UIImageView *_ivCurrentCard;
    
    // rule stuff
    UIImageView *_bgRule;
    UILabel *_lblRuleTitle;
    UILabel *_lblRuleDesc;
    UIButton *_btnFade;
    
    // next player popup
    UIButton *_btnFadePlayer;
    PlayerImageView *_nextPlayerView;
    
    bool _turnAllowed;
    bool _fadeAllowed;
    bool _doNextTurn;
    
    bool _fadePlayerAllowed;
    
    bool _showingNextPlayer;
    bool _animatingNextPlayer;
    
    bool _showingCard;
    bool _animatingCard;
    
    // call back
    __weak id _delegate;
}

@property (nonatomic, retain) NSMutableArray *players;
@property (nonatomic, retain) Card *currentCard;
@property (nonatomic, retain) GameCard *currentGameCard;
@property (nonatomic, retain) Deck *currentDeck;

@property (weak) id delegate;

- (void)newGame;

@end
