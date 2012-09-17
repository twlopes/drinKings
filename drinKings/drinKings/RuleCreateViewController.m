//
//  RuleCreateViewController.m
//  drinKings
//
//  Created by Tristan Lopes on 9/08/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "RuleCreateViewController.h"
#import "RuleCell.h"
#import "AppDelegate.h"

@interface RuleCreateViewController ()

@end

@implementation RuleCreateViewController

@synthesize theRule=_theRule, rules=_rules;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    _tv.delegate = self;
    _tv.dataSource = self;
    _tv.allowsSelectionDuringEditing = YES;
    _tv.autoresizesSubviews = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tv];
    
    if(_theRule==nil){
        self.title = @"Rules";
    }else{
        self.title = _theRule.name;
    }
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [self registerNotifications];
}

- (void)viewDidAppear:(BOOL)animated{
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    _tv.frame = CGRectMake(0, 0, w, h);
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [_tfName resignFirstResponder];
    [_tfDesc resignFirstResponder];
    
    [self saveRule];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark create rule

- (void)createRule{
    NSManagedObjectContext *moc;
    
    if (moc == nil) {
        DLog(@"nil");
        moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    if(_theRule==nil){
        _theRule = (Rule *)[NSEntityDescription insertNewObjectForEntityForName:@"Rule"
                                                            inManagedObjectContext:moc];
    }
}

- (void)saveRule{
    if(![_tfName.text isEqualToString:@""] && _tfName.text!=nil){
        
        [self createRule];
        
        _theRule.name = _tfName.text;
        _theRule.desc = _tfDesc.text;
        _theRule.holdable = [NSNumber numberWithBool:_switchHoldable.on];
        
        if(_theRule.shortName==nil || [_theRule.shortName isEqualToString:@""]){
            _theRule.shortName = _theRule.name;
        }
        
        [_theRule.managedObjectContext save:nil];
    }else if(_theRule!=nil){
        //_theRul
    }
}

#pragma mark -
#pragma mark buttons

#pragma mark -
#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RuleCell *cell;
    
    if(indexPath.row==0){
        // name
        static NSString *CellIdentifier = @"name";
        
        cell = (RuleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[RuleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if(_tfName==nil){
                _tfName = [[UITextField alloc] initWithFrame:CGRectZero];
            }
            _tfName.borderStyle = UITextBorderStyleNone;
            [_tfName setFont:[UIFont systemFontOfSize:15.0]];
            _tfName.secureTextEntry = NO;
            _tfName.keyboardAppearance = UIKeyboardTypeDefault;
            //textName.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [_tfName setTextAlignment:UITextAlignmentRight];
            _tfName.autocorrectionType = UITextAutocorrectionTypeDefault;
            _tfName.clearButtonMode = UITextFieldViewModeWhileEditing;
            [_tfName setBackgroundColor:[UIColor clearColor]];
            _tfName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _tfName.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
            _tfName.delegate = self;
            [cell.contentView addSubview:_tfName];
        }
        
        cell.label.text = @"Name";
        
        _tfName.textColor = [cell.detailTextLabel textColor];
        //textURL.frame = CGRectMake(cell.textLabel.frame.size.width+10, 0, cell.contentView.frame.size.width-(cell.textLabel.frame.size.width+10)-3, cell.contentView.frame.size.height);
        _tfName.frame = CGRectMake(70, 0, cell.contentView.frame.size.width-70-3, cell.contentView.frame.size.height);
        
        if(_theRule!=nil){
            _tfName.text = _theRule.name;
        }
        
        cell.infoString = nil;
    }
    
    if(indexPath.row==1){
        // holdable
        static NSString *CellIdentifier = @"hold";
        
        cell = (RuleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[RuleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            int width = cell.contentView.frame.size.width;
            int height = cell.contentView.frame.size.height;
            
            if(_switchHoldable==nil){
                _switchHoldable = [[UISwitch alloc] initWithFrame:CGRectMake(width-80, 4, width-13-3, 30)];
                _switchHoldable.frame = CGRectMake(width-_switchHoldable.frame.size.width-5, height/2-_switchHoldable.frame.size.height/2, _switchHoldable.frame.size.width, _switchHoldable.frame.size.height+5);
            }
            _switchHoldable.tag=1;
            _switchHoldable.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            //[_switchHoldable addTarget: self action: @selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_switchHoldable];
        }
        
        cell.label.text = @"Holdable";
        
        if(_theRule!=nil){
            DLog(@"holdable: %@", _theRule.holdable);
            if([_theRule.holdable isEqualToNumber:[NSNumber numberWithBool:YES]]){
                [_switchHoldable setOn:YES animated:NO];
            }else{
                [_switchHoldable setOn:NO animated:NO];
            }
        }
        
        cell.infoString = (NSMutableString*)@"Allows the card to be held and played at a later point in the game";
    }
    
    if(indexPath.row==2){
        // desc
        static NSString *CellIdentifier = @"desc";
        
        cell = (RuleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[RuleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if(_tfDesc==nil){
                _tfDesc = [[UITextView alloc] initWithFrame:CGRectZero];
            }
            [_tfDesc setFont:[UIFont systemFontOfSize:15.0]];
            _tfDesc.secureTextEntry = NO;
            _tfDesc.keyboardAppearance = UIKeyboardTypeDefault;
            //textName.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [_tfDesc setTextAlignment:UITextAlignmentLeft];
            _tfDesc.autocorrectionType = UITextAutocorrectionTypeDefault;
            [_tfDesc setBackgroundColor:[UIColor clearColor]];
            _tfDesc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
            _tfDesc.editable=YES;
            _tfDesc.delegate = self;
            [cell.contentView addSubview:_tfDesc];
        }
        
        cell.label.text = @"Description";
        cell.resizeLabel=NO;
        CGRect frame = cell.label.frame;
        frame.origin.y = 15;
        
        _tfDesc.textColor = [cell.detailTextLabel textColor];
        //textURL.frame = CGRectMake(cell.textLabel.frame.size.width+10, 0, cell.contentView.frame.size.width-(cell.textLabel.frame.size.width+10)-3, cell.contentView.frame.size.height);
        _tfDesc.frame = CGRectMake(105, 0, cell.contentView.frame.size.width-100-3, 200);
        
        if(_theRule!=nil){
            _tfDesc.text = _theRule.desc;
        }
        
        cell.infoString = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*if(_tv.editing){
        if(indexPath.row>=2){
            // send to edit
            Rule *aRule = [_arrayItems objectAtIndex:indexPath.row-2];
            
            RuleCreateViewController *rcvc = [[RuleCreateViewController alloc] init];
            rcvc.contentSizeForViewInPopover = CGSizeMake(320, 480);
            rcvc.theRule=aRule;
            rcvc.rules=self;
            [self.navigationController pushViewController:rcvc animated:YES];
        }
    }else{
        if(indexPath.row==0){
            // send to edit
            RuleCreateViewController *rcvc = [[RuleCreateViewController alloc] init];
            rcvc.contentSizeForViewInPopover = CGSizeMake(320, 480);
            rcvc.theRule=nil;
            rcvc.rules=self;
            [self.navigationController pushViewController:rcvc animated:YES];
        }else if(indexPath.row==1){
            [self setRule:nil];
        }else{
            Rule *aRule = [_arrayItems objectAtIndex:indexPath.row-2];
            
            [self setRule:aRule];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];*/
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        return 45;
    }
    
    if(indexPath.row==1){
        return 45;
    }
    
    if(indexPath.row==2){
        return 200;
    }
    
    return 0;
}

#pragma mark -
#pragma mark textfield

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    DLog(@"~");
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Keyboard stuff!

- (void)registerNotifications
{
    DLog(@"~");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    DLog(@"~");
        
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    
    if(([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)){
        
        contentInsets = UIEdgeInsetsMake(_tv.contentInset.top, _tv.contentInset.left, kbSize.width, _tv.contentInset.right);
        
    }else{
        
        contentInsets = UIEdgeInsetsMake(_tv.contentInset.top, _tv.contentInset.left, kbSize.height, _tv.contentInset.right);
        
    }
    
    _tv.contentInset = contentInsets;
    _tv.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    DLog(@"~");
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _tv.contentInset = contentInsets;
    _tv.scrollIndicatorInsets = contentInsets;
}


@end
