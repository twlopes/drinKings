//
//  CardsHelper.m
//  drinkingcards
//
//  Created by Tristan Lopes on 18/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "CardsHelper.h"
#import "RulesHelper.h"
#import "AppDelegate.h"
#import "Rule.h"
#import "GameCard.h"

@implementation CardsHelper

+ (void)setupCards{
    DLog(@"~");
    
    // this will setup the standard deck with standard rules
    
    NSManagedObjectContext *moc/* = [ac managedObjectContext]*/;
    
    if (moc == nil) { 
        DLog(@"nil");
        moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    // setup the rules
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Rule"
                                              inManagedObjectContext:moc];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    // if there are no rules then set up the standards
    if([array count]==0){
        
        Rule *rule;
        
        // ace
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                           inManagedObjectContext:moc];
        
        rule.shortName = @"Rule";
        rule.name = @"Make a Rule";
        rule.desc = @"Create a rule that all the players must obey until another ace is drawn and a new rule is made. The new rule voids the previous rule.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:0];
        
        // give
            // 2 drinks
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                           inManagedObjectContext:moc];
        
        rule.shortName = @"Give2";
        rule.name = @"Give 2 drinks";
        rule.desc = @"Choose a player to have 2 drinks!";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:2];
        
            // 3 drinks
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Give3";
        rule.name = @"Give 3 drinks";
        rule.desc = @"Choose a player to have 3 drinks!";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:3];
        
            // 4 drinks
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Give4";
        rule.name = @"Give 4 drinks";
        rule.desc = @"Choose a player to have 4 drinks!";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:4];
        
        // take
            // 2 drinks
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Take2";
        rule.name = @"Take 2 drinks";
        rule.desc = @"Whoops! Drink 2 fingers!";
        rule.giveable = [NSNumber numberWithInt:0];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:2];
        
            // 3 drinks
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Take3";
        rule.name = @"Take 3 drinks";
        rule.desc = @"Whoops! Drink 3 fingers!";
        rule.giveable = [NSNumber numberWithInt:0];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:3];
        
            // 4 drinks
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Take4";
        rule.name = @"Take 4 drinks";
        rule.desc = @"Whoops! Drink 4 fingers!";
        rule.giveable = [NSNumber numberWithInt:0];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:4];
        
        // 5
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Moose";
        rule.name = @"Moose!";
        rule.desc = @"Everyone must immediately put their thumbs to their head with his/her fingers splayed, resembling moose horns. The last person to do this must drink.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        // 6
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Nose";
        rule.name = @"Nose";
        rule.desc = @"At any point during the game the player can put their finger on their nose (the idea is to do it so that no one notices) the last person to notice and put their finger on their nose has to drink.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:YES];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        // 7
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Categories";
        rule.name = @"Categories";
        rule.desc = @"The player who drew the card picks a category such as \"sports teams\" or \"bands from the '90s,\" the players then go around in the circle saying items from that category, the first player who can not think of an item or says something not in the category (or if all items have been exhausted) must drink.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        // 8
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Never";
        rule.name = @"Never Have I Ever";
        rule.desc = @"Go around the circle playing Never Have I Ever. Drink each time you put down a finger. First person to put down all three fingers must take an extra drink, and the game continues.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        // 9
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Rhyme";
        rule.name = @"Busta Rhyme";
        rule.desc = @"Say a word, go around the circle rhyming with this word. This continues until someone takes too long or uses a word that has already been said, that person drinks.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        // 10
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Floor";
        rule.name = @"Floor!";
        rule.desc = @"The last player to touch the floor has to drink.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        // jack
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"FamousMales";
        rule.name = @"Famous Males";
        rule.desc = @"Go around the circle saying famous males names, the name must begin with the first letter of the previous names surname. This continues until someone takes too long or uses a word that has already been said, that person drinks. Names with the same first and last letter reverses the circle.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        // queen
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];

        rule.shortName = @"FamousFemales";
        rule.name = @"Famous Females";
        rule.desc = @"Go around the circle saying famous females names, the name must begin with the first letter of the previous names surname. This continues until someone takes too long or uses a word that has already been said, that person drinks. Names with the same first and last letter reverses the circle.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        // king
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Social";
        rule.name = @"Social!";
        rule.desc = @"Everyone have a drink!";
        rule.giveable = [NSNumber numberWithInt:2];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
    
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Thumb";
        rule.name = @"Thumb Master";
        rule.desc = @"The player who picks this card can place their thumb on the table at any time and the last player to notice and place their thumb in the same position must drink.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:YES];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
    
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Gambler";
        rule.name = @"Gambler's Fate";
        rule.desc = @"When a player draws this card they must guess the colour of the next card. If they get it wrong, they drink. If they get it right, they give a drink to another player.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Choker";
        rule.name = @"Choker";
        rule.desc = @"The person who drew the card must chug their beer until they finish it.";
        rule.giveable = [NSNumber numberWithInt:0];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Mate";
        rule.name = @"Mate";
        rule.desc = @"Pick a person to drink with you for the rest of the game.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:10];
        
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Guys";
        rule.name = @"Guys";
        rule.desc = @"All guys drink.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:10];
        
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Girls";
        rule.name = @"Girls";
        rule.desc = @"All girls drink.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:10];
        
        /*rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"God";
        rule.name = @"God";
        rule.desc = @"The player that has this card licks the back and sticks it to their forehead. For the duration of the time in which the card is on their forehead they can do anything they like, force any player to do what they like so long as it doesn't go against the basic rules of the game.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:10];*/
        
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Toilet";
        rule.name = @"Toilet Card";
        rule.desc = @"Only the holder of the card is permitted to use the toilet.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:YES];
        rule.numberOfDrinks = [NSNumber numberWithInt:0];
        
        
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Service";
        rule.name = @"Secret Service";
        rule.desc = @"At any point in the game the player can hold their finger to their ear, like they are in the secret service. The last person is the president and must drink.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:YES];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Heaven";
        rule.name = @"Heaven";
        rule.desc = @"All players must point toward the sky. The last player to point must drink.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Waterfall";
        rule.name = @"Waterfall";
        rule.desc = @"The player who drew this card begins to chug or sip, so then does everybody else. When the person who picked up the card stops drinking the person to their right can stop drinking. When that person stops drinking the person to their right can stop drinking. This goes to the end of the circle.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:10];
        
        rule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                     inManagedObjectContext:moc];
        
        rule.shortName = @"Nicknames";
        rule.name = @"Nicknames";
        rule.desc = @"The person who picks up the name must allocate an amusing nickname to a fellow player. From now on – if anyone addresses this player by their real name, they have to drink.";
        rule.giveable = [NSNumber numberWithInt:1];
        rule.holdable = [NSNumber numberWithBool:NO];
        rule.numberOfDrinks = [NSNumber numberWithInt:1];
        
        // if there were no rules then lets get rid of any existing decks or cards
        request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Deck"
                                       inManagedObjectContext:moc]];
        [request setIncludesPropertyValues:NO];
        error = nil;
        NSArray *deckArray = [moc executeFetchRequest:request error:&error];
        for(NSManagedObject *deck in deckArray){
            [moc deleteObject:deck];
        }
        
        request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Card"
                                       inManagedObjectContext:moc]];
        [request setIncludesPropertyValues:NO];
        error = nil;
        NSArray *cardArray = [moc executeFetchRequest:request error:&error];
        for(NSManagedObject *card in cardArray){
            [moc deleteObject:card];
        }
        
        [moc save:nil];
        
        
        
        // lets create the standard deck
        Deck *deck = (Deck *)[NSEntityDescription insertNewObjectForEntityForName:@"Deck"
                                                           inManagedObjectContext:moc];
        deck.name = @"Standard";
        
        // loop through the suits
        for(int suit=0; suit<4; suit++){
            NSMutableString *s = [[NSMutableString alloc] init];
            
            if(suit==0){
                [s appendString:@"Hearts"];
            }
            
            if(suit==1){
                [s appendString:@"Spades"];
            }
            
            if(suit==2){
                [s appendString:@"Diamonds"];
            }
            
            if(suit==3){
                [s appendString:@"Clubs"];
            }
            
            // loop through cards
            for(int i=1; i<=13; i++){
                
                /*NSEntityDescription* entity = [NSEntityDescription entityForName:@"Card"
                                                          inManagedObjectContext:moc];
                NSFetchRequest* request = [[NSFetchRequest alloc] init];
                [request setEntity:entity];
                
                [request setPredicate:[NSPredicate predicateWithFormat:@"suit = %@ AND number = %i", s, i]];
                
                NSError *error = nil;
                NSArray *cardArray = [moc executeFetchRequest:request error:&error];
                
                if([cardArray count]==0){*/
                    DLog(@"creating %i %@", i, s);
                    Card *card = (Card *)[NSEntityDescription insertNewObjectForEntityForName:@"Card"
                                                                         inManagedObjectContext:moc];
                    
                    card.number = [NSNumber numberWithInt:i];
                    card.suit = s;
                card.deck = deck;
                    
                    if(i==1){
                        // ace
                        card.rule = [RulesHelper ruleWithShortName:@"Rule"];
                    }
                    
                    if(i>=2 && i<=4){
                        if([s isEqual:@"Hearts"] || [s isEqual:@"Diamonds"]){
                            card.rule = [RulesHelper ruleWithShortName:[NSString stringWithFormat:@"Give%i", i]];
                        }else{
                            card.rule = [RulesHelper ruleWithShortName:[NSString stringWithFormat:@"Take%i", i]];
                        }
                    }
                    
                    if(i==5){
                        card.rule = [RulesHelper ruleWithShortName:@"Moose"];
                    }
                    
                    if(i==6){
                        card.rule = [RulesHelper ruleWithShortName:@"Nose"];
                    }
                    
                    if(i==7){
                        card.rule = [RulesHelper ruleWithShortName:@"Categories"];
                    }
                    
                    if(i==8){
                        card.rule = [RulesHelper ruleWithShortName:@"Never"];
                    }
                    
                    if(i==9){
                        card.rule = [RulesHelper ruleWithShortName:@"Rhyme"];
                    }
                    
                    if(i==10){
                        card.rule = [RulesHelper ruleWithShortName:@"Gambler"];
                    }
                    
                    if(i==11){
                        card.rule = [RulesHelper ruleWithShortName:@"FamousMales"];
                    }
                    
                    if(i==12){
                        card.rule = [RulesHelper ruleWithShortName:@"FamousFemales"];
                    }
                    
                    if(i==13){
                        card.rule = [RulesHelper ruleWithShortName:@"Social"];
                    }
                /*}else{
                    DLog(@"exists %i %@", i, s);
                }*/
                
                NSError *mocerror;
                if (![moc save:&mocerror]) {
                    NSLog(@"Whoops, couldn't save: %@", [mocerror localizedDescription]);
                }
            }
        }
        
        // we will still create the jokers but give them nil on the rule so they can't be played
        Card *card = (Card *)[NSEntityDescription insertNewObjectForEntityForName:@"Card"
                                                           inManagedObjectContext:moc];
        
        card.number = @0;
        card.suit = @"Red";
        card.deck = deck;
        card.rule = nil;
        
        NSError *mocerror;
        if (![moc save:&mocerror]) {
            NSLog(@"Whoops, couldn't save: %@", [mocerror localizedDescription]);
        }
        
        card = (Card *)[NSEntityDescription insertNewObjectForEntityForName:@"Card"
                                                     inManagedObjectContext:moc];
        
        card.number = @0;
        card.suit = @"Black";
        card.deck = deck;
        card.rule = nil;
        
        if (![moc save:&mocerror]) {
            NSLog(@"Whoops, couldn't save: %@", [mocerror localizedDescription]);
        }
    }
}

+ (NSString*)cardNameWithCard:(Card*)card{
    DLog(@"~ %@", card);
    NSMutableString *returnString=[[NSMutableString alloc] initWithString:@""];
    
    if([card.number intValue]==0){
        [returnString appendString:card.suit];
        [returnString appendString:@" Joker"];
    }else{
    
        if([card.number intValue]==1){
            [returnString appendString:@"Ace of "];
        }
        
        if([card.number intValue]>=2 && [card.number intValue]<=9){
            [returnString appendFormat:@"%i of ", [card.number intValue]];
        }
        
        if([card.number intValue]==11){
            [returnString appendString:@"Jack of "];
        }
        
        if([card.number intValue]==12){
            [returnString appendString:@"Queen of "];
        }
        
        if([card.number intValue]==13){
            [returnString appendString:@"King of "];
        }
        
        [returnString appendString:card.suit];
    }
    
    return returnString;
}

+ (UIImage*)imageForCard:(Card*)card{
    //DLog(@"~");
    NSMutableString *imageString=[[NSMutableString alloc] initWithString:@""];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        [imageString appendFormat:@"%i_%@@2x.png", [card.number intValue], [card.suit lowercaseString]];
    }else{
        [imageString appendFormat:@"%i_%@.png", [card.number intValue], [card.suit lowercaseString]];
    }
    
    DLog(@"%@", imageString);
    
    return [UIImage imageNamed:imageString];
}

+ (CGSize)sizeOfCard:(CGSize)board{
    //int numberOfCardsHorizontal;
    //int numberOfCardsVertical;
    
    // we need to figure out the optimal size of the cards
    // first find out which side is longer
    //if(board.width>board.height){
    // portrait
    //numberOfCardsHorizontal=8;
    //numberOfCardsVertical=6.5;
    //}else{
    // landscape
    //    numberOfCardsHorizontal=5;
    //    numberOfCardsVertical=10;
    //}
    
    // optimal height, number of cards plus 1 space
    float cardHeight = board.height / kNumberOfCardsVertical;
    float cardWidth = cardHeight * kCardRatio;
    
    DLog(@"card size: height: %f, width: %f", cardHeight, cardWidth);
    
    return CGSizeMake(cardWidth, cardHeight);
}

+ (void)positionCardsForGame:(Game*)game withDimensions:(CGSize)board{
    DLog(@"~");
    
    //int numberOfCardsHorizontal;
    //int numberOfCardsVertical;
    
    // we need to figure out the optimal size of the cards
    // first find out which side is longer
    //if(board.width>board.height){
    // portrait
    //numberOfCardsHorizontal=8;
    //numberOfCardsVertical=6.5;
    
    CGSize card = [self sizeOfCard:board];
    
    float cardHeight = card.height;
    float cardWidth = card.width;
    
    
    // now we know the optimal size we need to place them, randomly, on to the board
    NSArray *gameCardArray = [game.cards allObjects];
    NSMutableArray *randomIndex = [[NSMutableArray alloc] init];
    int r;
    while ([randomIndex count] < [gameCardArray count]) {
        r = arc4random()%[gameCardArray count];
        if (![randomIndex containsObject:[NSNumber numberWithInt:r]]) {
            [randomIndex addObject:[NSNumber numberWithInt:r]];
        }
    }
    
    DLog(@"width: %f, height: %f", board.width, board.height);
    
    for(int i=0; i<[gameCardArray count]; i++){
        GameCard *gc = [gameCardArray objectAtIndex:[[randomIndex objectAtIndex:i] intValue]];
        
        DLog(@" positioning card: %@ %@", gc.card.number, gc.card.suit);
        
        /*gc.positionX = [NSNumber numberWithFloat:cardWidth*(i%kNumberOfCardsHorizontal)];
        
        gc.positionY = [NSNumber numberWithFloat:cardHeight*(int)(i/kNumberOfCardsVertical - 0.5)];*/
        
        //gc.positionX = [NSNumber numberWithFloat:arc4random()%(int)(board.width-cardWidth)];
        gc.positionX = [NSNumber numberWithFloat:arc4random()%(int)(board.width-cardWidth*1.3) + cardWidth/6];
        
        //gc.positionY = [NSNumber numberWithFloat:arc4random()%(int)(board.height-cardHeight)];
        gc.positionY = [NSNumber numberWithFloat:arc4random()%(int)(board.height-cardHeight*1.3) + cardHeight/6 + board.height/13];
        
        gc.rotation = [NSNumber numberWithFloat:(2.0f * ((float)rand() / (float)RAND_MAX) - 1.0f)*0.5];
        
        DLog(@"positiong: %@ %@, rotation: %@", gc.positionX, gc.positionY, gc.rotation);
    }
}

@end
