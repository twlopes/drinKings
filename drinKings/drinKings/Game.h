//
//  Game.h
//  drinkingcards
//
//  Created by Tristan Lopes on 17/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameCard, GamePlayer;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSNumber * turn;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *cards;
@property (nonatomic, retain) NSSet *players;
@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addCardsObject:(GameCard *)value;
- (void)removeCardsObject:(GameCard *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

- (void)addPlayersObject:(GamePlayer *)value;
- (void)removePlayersObject:(GamePlayer *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;

@end
