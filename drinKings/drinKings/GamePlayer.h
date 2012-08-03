//
//  GamePlayer.h
//  drinKings
//
//  Created by Tristan Lopes on 24/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, GameCard, Player;

@interface GamePlayer : NSManagedObject

@property (nonatomic, retain) NSNumber * drinksGiven;
@property (nonatomic, retain) NSNumber * drinksTaken;
@property (nonatomic, retain) NSNumber * playerTurn;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) NSSet *cards;
@end

@interface GamePlayer (CoreDataGeneratedAccessors)

- (void)addCardsObject:(GameCard *)value;
- (void)removeCardsObject:(GameCard *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

@end
