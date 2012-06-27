//
//  GamePlayer.h
//  drinkingcards
//
//  Created by Tristan Lopes on 17/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Player;

@interface GamePlayer : NSManagedObject

@property (nonatomic, retain) NSNumber * drinksGiven;
@property (nonatomic, retain) NSNumber * drinksTaken;
@property (nonatomic, retain) NSNumber * playerTurn;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) Player *player;

@end
