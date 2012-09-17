//
//  RulesListViewController.m
//  drinKings
//
//  Created by Tristan Lopes on 9/08/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "RulesListViewController.h"
#import "AppDelegate.h"
#import "RuleCreateViewController.h"
#import "Card.h"

@interface RulesListViewController ()

@end

@implementation RulesListViewController

@synthesize cards=_cards;

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
    
    self.view.autoresizesSubviews = UIViewAutoresizingFlexibleHeight;
    
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    _tv.delegate = self;
    _tv.dataSource = self;
    _tv.allowsSelectionDuringEditing = YES;
    _tv.autoresizesSubviews = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tv];
    
    self.title = @"Rules";
    
    if([self isModal]){
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(touchClose)];
        
        self.navigationItem.leftBarButtonItem = btn;
    }
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(touchEdit)];
    
    self.navigationItem.rightBarButtonItem = btn;
}

- (void)viewDidAppear:(BOOL)animated{
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    _tv.frame = CGRectMake(0, 0, w, h);
    
    [self updateFromDB];
}

- (void)viewWillAppear:(BOOL)animated{
    [self updateFromDB];
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
#pragma mark DB

- (void)updateFromDB{
    NSManagedObjectContext *moc;
    
    if (moc == nil) {
        DLog(@"nil");
        moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    _arrayItems = (NSMutableArray*)[[moc fetchObjectsForEntityName:@"Rule"] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    [_tv reloadData];
}

-(BOOL)isModal {
    
    BOOL isModal = ((self.parentViewController && self.parentViewController.modalViewController == self) ||
                    //or if I have a navigation controller, check if its parent modal view controller is self navigation controller
                    ( self.navigationController && self.navigationController.parentViewController && self.navigationController.parentViewController.modalViewController == self.navigationController) ||
                    //or if the parent of my UITabBarController is also a UITabBarController class, then there is no way to do that, except by using a modal presentation
                    [[[self tabBarController] parentViewController] isKindOfClass:[UITabBarController class]]);
    
    //iOS 5+
    if (!isModal && [self respondsToSelector:@selector(presentingViewController)]) {
        
        isModal = ((self.presentingViewController && self.presentingViewController.modalViewController == self) ||
                   //or if I have a navigation controller, check if its parent modal view controller is self navigation controller
                   (self.navigationController && self.navigationController.presentingViewController && self.navigationController.presentingViewController.modalViewController == self.navigationController) ||
                   //or if the parent of my UITabBarController is also a UITabBarController class, then there is no way to do that, except by using a modal presentation
                   [[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]]);
        
    }
    
    return isModal;        
    
}

#pragma mark -
#pragma mark Buttons

- (void)touchClose{
    DLog(@"~");
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchEdit{
    DLog(@"~");
    
    if(_tv.editing){
        [_tv setEditing:NO animated:YES];
    }else{
        [_tv setEditing:YES animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.cancelButtonIndex==buttonIndex){
        // delete
        Rule *aRule = [_arrayItems objectAtIndex:_deleteRow];
        
        for(Card *aCard in [aRule.cards allObjects]){
            aCard.rule = nil;
        }
        
        NSManagedObjectContext *moc;
        if (moc == nil) {
            moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        }

        [moc deleteObject:aRule];
        [moc save:nil];
        
        [self updateFromDB];
    }
    
    [_tv reloadData];
    [_cards.gv reloadData];
    _deleteRow=0;
}

#pragma mark -
#pragma mark cards

- (void)setRule:(Rule*)rule{
    [_cards setRule:rule];
}

#pragma mark -
#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrayItems count]+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Nothing";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    if(indexPath.row==0){
        cell.textLabel.text = @"Add Rule";
        cell.textLabel.textColor = [Skins colorWithHexString:@"347235"];
        
        cell.detailTextLabel.text = nil;
    }else if(indexPath.row==1){
        cell.textLabel.text = @"No Rule";
        cell.textLabel.textColor =  [Skins colorWithHexString:@"C11B17"];
        
        cell.detailTextLabel.text = nil;
    }else{
        Rule *aRule = [_arrayItems objectAtIndex:indexPath.row-2];
        
        cell.textLabel.text = aRule.name;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = aRule.desc;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_tv.editing){
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0 || indexPath.row==1){
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"~");
    
    _deleteRow=indexPath.row-2;
    
    Rule *aRule = [_arrayItems objectAtIndex:_deleteRow];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure you want to delete '%@'?", aRule.name] message:@"All cards with this rule will be set to 'no rule'" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"No", nil];
    [alert show];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row<=1){
        return 40;
    }
    
    return 70;
}

@end
