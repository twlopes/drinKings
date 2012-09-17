//
//  CardsViewController.m
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "CardsViewController.h"
#import "CardsHelper.h"
#import "Deck.h"
#import "AppDelegate.h"
#import "Card.h"
#import "CardGridViewCell.h"
#import "Rule.h"
#import "RulesListViewController.h"

@interface CardsViewController ()

@end

@implementation CardsViewController

@synthesize theDeck=_theDeck, gv=_gv;

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = _theDeck.name;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    _chosenItems = [[NSMutableArray alloc] init];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _itemSize = CGSizeMake(175.0*kCardRatio, 175.0);
    }else{
        _itemSize = CGSizeMake(300.0*kCardRatio, 300.0);
    }
    
    _gv = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, w, /*h-h/8*/h)];
    _gv.scrollsToTop = YES;
    //_gv.backgroundColor = [UIColor darkGrayColor];
    //_gv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    _gv.backgroundColor = [UIColor clearColor];
    _gv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gv.autoresizesSubviews = YES;
    _gv.dataSource = self;
    _gv.delegate = self;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [_gv setGridFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 60)]];
    }else{
        [_gv setGridFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h/8)]];
    }
    [self.view addSubview:_gv];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"Rename" style:UIBarButtonItemStylePlain target:self action:@selector(touchRename)];
    
    self.navigationItem.rightBarButtonItem = btn;
    
    [self updateFromDB];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateFromDB];
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    float y = h-h/7;
    
    _gv.frame = CGRectMake(0, 0, w, h/*-h/6*/);
    
    [_gv flashScrollIndicators];
    
    if(_viewToolbar==nil){
        _viewToolbar = [[UIView alloc] initWithFrame:CGRectMake(0, h-h/6, w, h/6)];
        _viewToolbar.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        [self.view addSubview:_viewToolbar];
    }
    
    if(_btnSelectAll==nil){
        _btnSelectAll = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnSelectAll useWhiteStyle];
        _btnSelectAll.frame = CGRectMake(w/3-w/3.2, y, w/3.5, h/9);
        [_btnSelectAll setTitle:@"Select All" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [_btnSelectAll.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        }else{
            [_btnSelectAll.titleLabel setFont:[UIFont systemFontOfSize:24.0f]];
        }
        [_btnSelectAll addTarget:self action:@selector(touchSelectAll) forControlEvents:UIControlEventTouchUpInside];
        _btnSelectAll.layer.shadowColor = [UIColor blackColor].CGColor;
        _btnSelectAll.layer.shadowOpacity = 0.65;
        _btnSelectAll.layer.shadowOffset = CGSizeMake(0,4);
        [self.view addSubview:_btnSelectAll];
    }
    
    if(_btnSelectNone==nil){
        _btnSelectNone = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnSelectNone useBlackActionSheetStyle];
        _btnSelectNone.frame = CGRectMake(w-w/3.5-(w/3-w/3.2), y, w/3.5, h/9);
        [_btnSelectNone setTitle:@"Select None" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [_btnSelectNone.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        }else{
            [_btnSelectNone.titleLabel setFont:[UIFont systemFontOfSize:24.0f]];
        }
        [_btnSelectNone addTarget:self action:@selector(touchSelectNone) forControlEvents:UIControlEventTouchUpInside];
        _btnSelectNone.layer.shadowColor = [UIColor blackColor].CGColor;
        _btnSelectNone.layer.shadowOpacity = 0.65;
        _btnSelectNone.layer.shadowOffset = CGSizeMake(0,4);
        [self.view addSubview:_btnSelectNone];
    }
    
    if(_btnRules==nil){
        _btnRules = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnRules useSimpleOrangeStyle];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [_btnRules.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        }else{
            [_btnRules.titleLabel setFont:[UIFont systemFontOfSize:24.0f]];
        }
        _btnRules.frame = CGRectMake(w/2-(w/3)/2, y, w/3, h/9);
        [_btnRules setTitle:@"Rules" forState:UIControlStateNormal];
        [_btnRules addTarget:self action:@selector(touchRules) forControlEvents:UIControlEventTouchUpInside];
        _btnRules.layer.shadowColor = [UIColor blackColor].CGColor;
        _btnRules.layer.shadowOpacity = 0.65;
        _btnRules.layer.shadowOffset = CGSizeMake(0,4);
        [self.view addSubview:_btnRules];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    }
}

- (void)updateFromDB{
    
    NSArray *sortArray = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"suit" ascending:YES], nil];
    
    _arrayItems = (NSMutableArray*)[[_theDeck.cards allObjects] sortedArrayUsingDescriptors:sortArray];
    
    DLog(@"arrayItems %@", _arrayItems);
    
    [_gv reloadData];
}

#pragma mark -
#pragma mark delegate

- (void)setRule:(Rule*)rule{
    // set this rule to all the selected cards
    for(Card *aCard in _chosenItems){
        aCard.rule = rule;
        
        [aCard.managedObjectContext save:nil];
    }
    
    // close
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }else{
        [_popover dismissPopoverAnimated:YES];
    }
    
    [_gv reloadData];
}

#pragma mark -
#pragma mark buttons

- (void)touchSelectAll{
    DLog(@"~");

    for(Card *aCard in _arrayItems){
        if(![_chosenItems containsObject:aCard]){
            [_chosenItems addObject:aCard];
        }
    }
    
    [_gv reloadData];
}

- (void)touchSelectNone{
    DLog(@"~");
    
    [_chosenItems removeAllObjects];
    
    [_gv reloadData];
}

- (void)touchRules{
    DLog(@"~");
    
    RulesListViewController *rlvc = [[RulesListViewController alloc] init];
    rlvc.contentSizeForViewInPopover = CGSizeMake(320, 480);
    rlvc.cards = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rlvc];
    nav.contentSizeForViewInPopover = CGSizeMake(320, 480);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        
        [self.navigationController presentModalViewController:nav animated:YES];
    }else{
        if([UINavigationBar conformsToProtocol:@protocol(UIAppearance)]){
            [nav.navigationBar setBackgroundImage:nil
                                    forBarMetrics:UIBarMetricsDefault];
            [nav.navigationBar setBackgroundImage:nil
                                    forBarMetrics:UIBarMetricsLandscapePhone];
        }
        
        _popover = [[UIPopoverController alloc] initWithContentViewController:nav];
        _popover.delegate = (id<UIPopoverControllerDelegate>)self;
        [_popover presentPopoverFromRect:_btnRules.frame
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionDown
                                animated:YES];
    }
}

- (void)touchRename{
    DLog(@"~");
    
    UIAlertView * alert;
    
    if([[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] == NSOrderedAscending){
        // need to build our own
        alert = [[UIAlertView alloc] initWithTitle:@"Enter new name" message:@"\n\n" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        _tfRename = [[UITextField alloc] init];
        [_tfRename setBackgroundColor:[UIColor whiteColor]];
        _tfRename.delegate = self;
        _tfRename.borderStyle = UITextBorderStyleLine;
        _tfRename.frame = CGRectMake(15, 60, 255, 30);
        _tfRename.font = [UIFont fontWithName:@"ArialMT" size:20];
        _tfRename.text = _theDeck.name;
        _tfRename.keyboardAppearance = UIKeyboardAppearanceAlert;
        _tfRename.clearButtonMode = UITextFieldViewModeAlways;
        [_tfRename becomeFirstResponder];
        [alert addSubview:_tfRename];
    }else{
        alert = [[UIAlertView alloc] initWithTitle:@"Enter new name" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.text = _theDeck.name;
        alertTextField.clearButtonMode = UITextFieldViewModeAlways;
        
    }
    
    alert.tag=5;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag==5){
        
        NSString *str=nil;
        
        if([[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] == NSOrderedAscending){
        
            str = _tfRename.text;
        }else{
            UITextField * alertTextField = [alertView textFieldAtIndex:0];
            
            str = alertTextField.text;
        }
        
        if(str!=nil && ![str isEqual:@""]){
            _theDeck.name = str;
            
            [_theDeck.managedObjectContext save:nil];
            self.title = _theDeck.name;
        }
    }
}

#pragma mark -
#pragma mark Grid View Data Source

- (void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    
    DLog (@"Selected theArgument=%d\n", index);
    
    Card *aCard = [_arrayItems objectAtIndex:index];
    
    if([_chosenItems containsObject:aCard]){
        DLog(@"remove %@", aCard);
        [_chosenItems removeObject:aCard];
    }else{
        DLog(@"add %@", aCard);
        [_chosenItems addObject:aCard];
    }
    
    [_gv deselectItemAtIndex:index animated:NO];
    [_gv reloadData];
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    DLog(@"~ %i", [_arrayItems count]);
    return [_arrayItems count];
    //return 10;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    DLog(@"~");
    
    NSString *cellIdentifier = @"cell";
    
    CardGridViewCell * cell = (CardGridViewCell *)[_gv dequeueReusableCellWithIdentifier: cellIdentifier];
    if ( cell == nil )
    {
        cell = [[CardGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, _itemSize.width, _itemSize.height)
                                       reuseIdentifier: cellIdentifier];
        //cell.selectionGlowColor = [UIColor colorWithRed:81.0/256 green:102.0/265 blue:145.0/256 alpha:1.0];
        //cell.selectionGlowColor = [Skins colorWithHexString:@"FFFF00" alpha:0.4];
        //cell.selectionGlowColor = [UIColor colorWithRed:81.0/256 green:102.0/265 blue:145.0/256 alpha:0.5];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = AQGridViewCellSelectionStyleNone;
    }
    
    Card *aCard = [_arrayItems objectAtIndex:index];
    
    if(aCard.rule==nil){
        cell.lblName.text = @"No Rule";
        cell.lblName.textColor = [UIColor redColor];
    }else{
        cell.lblName.text = aCard.rule.name;
        cell.lblName.textColor = [UIColor whiteColor];
    }
    [cell.ivCard setImage:[CardsHelper imageForCard:aCard]];
    
    if([_chosenItems containsObject:aCard]){
        [cell.viewSelect setBackgroundColor:[UIColor colorWithRed:81.0/256 green:102.0/265 blue:145.0/256 alpha:1.0]];
    }else{
        [cell.viewSelect setBackgroundColor:[UIColor clearColor]];
    }
    
    /*cell.player.image.alpha = 1.0;
     
     Player *aPlayer = [_arrayItems objectAtIndex:index-1];
     
     cell.player.name.text = aPlayer.name;
     
     cell.player.image.image = [UIImage imageWithData:aPlayer.photo];
     
     if([_chosenItems containsObject:aPlayer]){
     DLog(@"contains %@", aPlayer);
     //[cell setSelected:YES];
     //cell.selected=YES;
     }else{
     DLog(@"nope %@", aPlayer);
     //[cell setSelected:NO];
     //cell.selected=NO;
     }
     
     if([_chosenItems containsObject:aPlayer]){
     [cell.player setBackgroundColor:[UIColor colorWithRed:81.0/256 green:102.0/265 blue:145.0/256 alpha:1.0]];
     }else{
     [cell.player setBackgroundColor:[UIColor whiteColor]];
     }
     
     if(_editMode){
     cell.btnDelete.hidden=NO;
     cell.btnDelete.tag = index-1;
     [cell.btnDelete addTarget:self action:@selector(confirmDeleteItem:) forControlEvents:UIControlEventTouchUpInside];
     }else{
     cell.btnDelete.hidden=YES;
     }*/

    
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    DLog(@"~");
    
    /*float w = self.view.frame.size.width;
     float h = self.view.frame.size.height;
     
     CGSize size;
     
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     size = CGSizeMake(120.0, 160.0);
     }else{
     size = CGSizeMake(240.0, 320.0);
     }
     
     DLog(@"%f %f", size.width, size.height);*/
    
    CGSize size = CGSizeMake(_itemSize.width+10, _itemSize.height+5);
    
    return size;
}

@end
