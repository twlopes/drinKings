//
//  GameCard.h
//  drinkingcards
//
//  Created by Tristan Lopes on 17/06/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card, Game, Player;

@interface GameCard : NSManagedObject

@property (nonatomic, retain) NSNumber * played;
@property (nonatomic, retain) NSNumber * positionX;
@property (nonatomic, retain) NSNumber * positionY;
@property (nonatomic, retain) NSNumber * rotation;
@property (nonatomic, retain) NSNumber * tag;
@property (nonatomic, retain) NSNumber * holding;
@property (nonatomic, retain) Card *card;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) Player *player;

@end
