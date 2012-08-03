//
//  CardsViewController.h
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"
#import "Deck.h"
#import "GradientButton.h"

@interface CardsViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
    
    Deck *_theDeck;
    
    // Data
    NSMutableArray *_arrayItems;
    NSMutableArray *_chosenItems;
    
    // Interface
    AQGridView *_gv;
    CGSize _itemSize;
    
    // Footer
    GradientButton *_btnSelectAll;
    GradientButton *_btnSelectNone;
    GradientButton *_btnRules;
}

@property (nonatomic, retain) Deck *theDeck;

@end
