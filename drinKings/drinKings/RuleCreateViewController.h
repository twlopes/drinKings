//
//  RuleCreateViewController.h
//  drinKings
//
//  Created by Tristan Lopes on 9/08/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rule.h"
#import "RulesListViewController.h"

@interface RuleCreateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate>{
    
    UITableView *_tv;
    
    Rule *_theRule;
    
    RulesListViewController *_rules;
    
    // UI
    UITextField *_tfName;
    UISwitch *_switchHoldable;
    UITextView *_tfDesc;
}

@property (nonatomic, retain) Rule *theRule;
@property (nonatomic, retain) RulesListViewController *rules;

@end
