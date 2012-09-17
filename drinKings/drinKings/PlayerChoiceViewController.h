//
//  PlayerChoiceViewController.h
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"
#import "GradientButton.h"
#import "MBProgressHUD.h"

@interface PlayerChoiceViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource, UIActionSheetDelegate> {
    // Data
    NSMutableArray *_arrayItems;
    NSMutableArray *_chosenItems;
    
    // Interface
    AQGridView *_gv;
    UIView *_viewToolbar;
    GradientButton *_btnPlay;
    CGSize _playerSize;
    MBProgressHUD* hud;
    
    // edit
    BOOL _editMode;
}

@property (nonatomic,retain) NSMutableArray *chosenItems;

- (void)addPlayer;

@end
