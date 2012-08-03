//
//  GameCard.h
//  drinKings
//
//  Created by Tristan Lopes on 24/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card, Game, GamePlayer;

@interface GameCard : NSManagedObject

@property (nonatomic, retain) NSNumber * holding;
@property (nonatomic, retain) NSNumber * played;
@property (nonatomic, retain) NSNumber * positionX;
@property (nonatomic, retain) NSNumber * positionY;
@property (nonatomic, retain) NSNumber * rotation;
@property (nonatomic, retain) NSNumber * tag;
@property (nonatomic, retain) Card *card;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) GamePlayer *player;

@end
