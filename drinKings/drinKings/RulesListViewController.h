//
//  RulesListViewController.h
//  drinKings
//
//  Created by Tristan Lopes on 9/08/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardsViewController.h"

@interface RulesListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tv;
    
    CardsViewController *_cards;
    
    NSArray *_arrayItems;
    
    // Delete
    int _deleteRow;
}

@property (nonatomic,retain) CardsViewController *cards;

@end
