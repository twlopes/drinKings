//
//  DecksViewController.m
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "DecksViewController.h"
#import "CardsHelper.h"
#import "Deck.h"
#import "AppDelegate.h"
#import "DeckGridViewCell.h"
#import "CardsViewController.h"

@interface DecksViewController ()

@end

@implementation DecksViewController

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
    
    self.title = @"Decks";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGreen.png"]];
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _itemSize = CGSizeMake(150.0*kCardRatio, 150.0);
    }else{
        _itemSize = CGSizeMake(300.0*kCardRatio, 300.0);
    }

    _gv = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    _gv.scrollsToTop = YES;
    //_gv.backgroundColor = [UIColor darkGrayColor];
    _gv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    _gv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gv.autoresizesSubviews = YES;
    _gv.dataSource = self;
    _gv.delegate = self;
    [self.view addSubview:_gv];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateFromDB];
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
    NSManagedObjectContext *moc;
    
    if (moc == nil) {
        DLog(@"nil");
        moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    _arrayItems = (NSMutableArray*)[moc fetchObjectsForEntityName:@"Deck"];
    
    DLog(@"arrayItems %@", _arrayItems);
    
    [_gv reloadData];
}

#pragma mark -
#pragma mark Grid View Data Source

- (void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    
    DLog (@"Selected theArgument=%d\n", index);
    
    if(index==0){
        // add
    }else{
        Deck *aDeck = [_arrayItems objectAtIndex:index-1];
        
        CardsViewController *cards = [[CardsViewController alloc] init];
        cards.theDeck = aDeck;
        [self.navigationController pushViewController:cards animated:YES];
    }
    
    [_gv deselectItemAtIndex:index animated:NO];
    [_gv reloadData];
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    DLog(@"~ %i", MAX(1, [_arrayItems count]+1));
    return MAX(1, [_arrayItems count]+1);
    //return 10;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    DLog(@"~");
    
    NSString *cellIdentifier = @"cell";
    
    DeckGridViewCell * cell = (DeckGridViewCell *)[_gv dequeueReusableCellWithIdentifier: cellIdentifier];
    if ( cell == nil )
    {
        cell = [[DeckGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, _itemSize.width, _itemSize.height)
                                     reuseIdentifier: cellIdentifier];
        //cell.selectionGlowColor = [UIColor colorWithRed:81.0/256 green:102.0/265 blue:145.0/256 alpha:1.0];
        cell.selectionGlowColor = [UIColor yellowColor];
        //cell.backgroundColor = [UIColor clearColor];
    }
    
    if(index==0){
        
        cell.lblName.text = @"Create new deck";
        
        /*cell.player.name.text = @"Create New Player";
        [cell.player.btnPlayer addTarget:self action:@selector(addPlayer) forControlEvents:UIControlEventTouchUpInside];
        cell.player.image.image=[UIImage imageNamed:@"defaultUser.png"];
        cell.player.image.alpha = 0.5;
        [cell.player setBackgroundColor:[UIColor whiteColor]];
        cell.btnDelete.hidden=YES;*/
    }else{
        
        Deck *aDeck = [_arrayItems objectAtIndex:index-1];
        
        cell.lblName.text = aDeck.name;
        
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
    }
    
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
    
    CGSize size = CGSizeMake(_itemSize.width+10, _itemSize.height+15);
    
    return size;
}

@end
