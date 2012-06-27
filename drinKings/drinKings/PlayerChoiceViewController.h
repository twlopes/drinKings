//
//  PlayerChoiceViewController.h
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"

@interface PlayerChoiceViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
    // Data
    NSMutableArray *_arrayItems;
    NSMutableArray *_chosenItems;
    
    // Interface
    AQGridView *_gv;
    UIButton *_btnPlay;
    CGSize _playerSize;
    
    // edit
    BOOL _editMode;
}

@property (nonatomic,retain) NSMutableArray *chosenItems;

- (void)addPlayer;

@end
