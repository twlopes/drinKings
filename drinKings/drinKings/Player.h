//
//  Player.h
//  drinkingcards
//
//  Created by Tristan Lopes on 17/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GamePlayer;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSSet *games;
@end

@interface Player (CoreDataGeneratedAccessors)

- (void)addGamesObject:(GamePlayer *)value;
- (void)removeGamesObject:(GamePlayer *)value;
- (void)addGames:(NSSet *)values;
- (void)removeGames:(NSSet *)values;

@end
