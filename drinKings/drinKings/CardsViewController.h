//
//  CardsViewController.h
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rule.h"
#import "AQGridViewCell.h"
#import "Deck.h"
#import "GradientButton.h"

@interface CardsViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource, UITextFieldDelegate> {
    
    Deck *_theDeck;
    
    // Data
    NSMutableArray *_arrayItems;
    NSMutableArray *_chosenItems;
    
    // Interface
    AQGridView *_gv;
    CGSize _itemSize;
    UITextField *_tfRename;
    
    // Footer
    UIView *_viewToolbar;
    GradientButton *_btnSelectAll;
    GradientButton *_btnSelectNone;
    GradientButton *_btnRules;
    
    // Rules
    UIPopoverController *_popover;
}

@property (nonatomic, retain) Deck *theDeck;
@property (nonatomic, retain) AQGridView *gv;

- (void)setRule:(Rule*)rule;

@end
