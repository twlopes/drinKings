//
//  PlayerCreateViewController.m
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "PlayerCreateViewController.h"
#import "AppDelegate.h"
#import "Player.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "CardsHelper.h"

@implementation PlayerCreateViewController

@synthesize popover=_popover, player=_player, parent=_parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        /*if (self.view.frame.size.width < self.view.frame.size.height){
         w = self.view.frame.size.height;
         h = self.view.frame.size.width;
         }else{
         w = self.view.frame.size.width;
         h = self.view.frame.size.height;
         }*/
        w = self.view.bounds.size.width;
        h = self.view.bounds.size.height;
    }
    
    int border = w/30;
    
    DLog(@"w=%f h=%f", w, h);
    
    if(_sv==nil){
        _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _sv.contentSize = CGSizeMake(w, h);
        _sv.scrollEnabled=NO;
        _sv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_sv];
    }
    
    float vH = h-border*2;
    float vW = vH*kCardRatio;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && h>=500) {
        vW = w-border*2;
        vH = vW/kCardRatio;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        //vH = (h-border*2)*kCardRatio;
        //vW = h-border*2;
    }
    
    DLog(@"card h %f -- w %f", vH, vW);
    
    if(_viewBG==nil){
        _viewBG = [[UIView alloc] initWithFrame:CGRectMake((w/2) - vW/2, border, vW, vH)];
        _viewBG.backgroundColor = [UIColor whiteColor];
        _viewBG.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _viewBG.layer.shadowColor = [UIColor blackColor].CGColor;
        _viewBG.layer.shadowOpacity = 0.65;
        _viewBG.layer.shadowOffset = CGSizeMake(0,4);
        [_sv addSubview:_viewBG];
    }
    
    
    w = _viewBG.frame.size.width;
    h = _viewBG.frame.size.height;
    
    if(_ivPlayer==nil){
        _ivPlayer = [[UIImageView alloc] initWithFrame:CGRectMake(border, border, w-(border*2), h-(border*2)-(border*4))];
        _ivPlayer.backgroundColor = [UIColor lightGrayColor];
        _ivPlayer.contentMode = UIViewContentModeScaleAspectFill;
        _ivPlayer.clipsToBounds=YES;
        _ivPlayer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        [_viewBG addSubview:_ivPlayer];
    }
    
    if(_btnCamera==nil){
        _btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCamera.frame = _ivPlayer.frame;
        _btnCamera.backgroundColor = [UIColor clearColor];
        _btnCamera.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        [_btnCamera addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
        [_viewBG addSubview:_btnCamera];
    }
    
    if(_tfName==nil){
        _tfName = [[UITextField alloc] initWithFrame:CGRectMake(border, h-(border*4.5), w-(border*2), border*4)];
        _tfName.borderStyle = UITextBorderStyleNone;
        _tfName.keyboardType = UIKeyboardTypeDefault;
        _tfName.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tfName.backgroundColor = [UIColor whiteColor];
        _tfName.textAlignment = UITextAlignmentCenter;
        _tfName.font = [UIFont systemFontOfSize:border*1.5];
        _tfName.placeholder = @"Enter Name...";
        _tfName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _tfName.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        _tfName.delegate=self;
        [_viewBG addSubview:_tfName];
    }
    
    CGRect f = _tfName.frame;;
    
    DLog(@"reporting tf frame %f %f %f %f", f.origin.x, f.origin.y, f.size.width, f.size.height);
    
    if(_player!=nil){
        _tfName.text = _player.name;
    }
    
    [self refreshImage];
}

- (void)refreshImage{
    
    if(_image!=nil){
        _ivPlayer.image = _image;
    }else if(_player!=nil){
        if(_player.photo!=nil){
            _ivPlayer.image = [UIImage imageWithData:_player.photo];
        }
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNotifications];
    
    _changed=NO;
    _forceSelect=NO;
    
    [self rightButton];
    
    /*self.navigationItem.backBarButtonItem.target = self;
    self.navigationItem.backBarButtonItem.action = @selector(backButtonDidPressed:);*/
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                   target: self
                                                  action: @selector(backButtonDidPressed:)]; 
    
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        /*if (self.view.frame.size.width < self.view.frame.size.height){
            w = self.view.frame.size.height;
            h = self.view.frame.size.width;
        }else{
            w = self.view.frame.size.width;
            h = self.view.frame.size.height;
        }*/
        w = self.view.bounds.size.width;
        h = self.view.bounds.size.height;
    }
    
    DLog(@"w=%f h=%f", w, h);
    
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    
    
    
    
    
    if(_player==nil){
        self.title = @"New Player";
    }else{
        self.title = @"Edit Player";
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [hud hide:NO];
    hud.delegate=nil;
    
    if(_forceSelect){
        if(![_parent.chosenItems containsObject:_player]){
            [_parent.chosenItems addObject:_player];
            
            DLog(@"chosen %@ - %@", _parent.chosenItems, _player);
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (void)rightButton{
    if(_changed){
        UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
        [self.navigationItem setRightBarButtonItem:save];
    }else{
        [self.navigationItem setRightBarButtonItem:nil];
    }
}

#pragma mark - Keyboard

- (void)registerNotifications
{
    DLog(@"~");
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];	
    
}

- (void)keyboardWillShow:(NSNotification*)note
{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    CGRect svFrame = _sv.frame;
    svFrame.size.height = self.view.bounds.size.height - keyboardBounds.size.height;
    _sv.scrollEnabled=YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    //_viewBG.frame = bgFrame;
    
    //_sv.frame = svFrame;
    //_sv.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - keyboardBounds.size.height);
    _sv.scrollEnabled=YES;
    _sv.contentInset = UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0);
    
    
    
    // commit animations
    [UIView commitAnimations];
}
       
- (void)keyboardDidShow:(NSNotification*)note
{
    DLog(@"~");
    DLog(@"~");
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    DLog(@"~");
    CGPoint bottomOffset;
    
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    DLog(@"~");
    if (orientation== UIDeviceOrientationPortrait || orientation==UIDeviceOrientationPortraitUpsideDown){
        bottomOffset = CGPointMake(0, _sv.contentSize.height - _sv.bounds.size.height + _sv.contentInset.bottom);
    }else{
        //bottomOffset = CGPointMake(0, _sv.contentSize.height - _sv.bounds.size.height);
        bottomOffset = CGPointMake(0, _sv.contentSize.height - _sv.bounds.size.height + _sv.contentInset.bottom);
    }
    DLog(@"%f", bottomOffset.y);
    [_sv setContentOffset:bottomOffset animated:YES];
    DLog(@"!");
}

- (void)keyboardWillHide:(NSNotification*)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    
    CGRect svFrame = _sv.frame;
    svFrame.size.height = self.view.bounds.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    //_sv.frame = svFrame;
    
    //_sv.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    _sv.scrollEnabled=NO;
    _sv.contentInset = UIEdgeInsetsZero;
    
    [_sv setContentOffset:CGPointMake(0,0) animated:YES];
    
    // commit animations
    [UIView commitAnimations];
    
    CGRect f = _tfName.frame;;
    DLog(@"reporting tf frame %f %f %f %f", f.origin.x, f.origin.y, f.size.width, f.size.height);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    _changed=YES;
    
    [self rightButton];
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    DLog(@"~");
    [textField resignFirstResponder];
    
    if(_player!=nil && ![textField.text isEqualToString:_player.name]){
        _changed=YES;
        
        [self rightButton];
        
        self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                      target: self
                                                      action: @selector(backButtonDidPressed:)]; 
    }
    
    return YES;
}

#pragma mark - Buttons

- (void)save{
    DLog(@"~");
    
    bool error=NO;
    
    if(_tfName.text==nil){
        error=YES;
    }
    
    [_tfName resignFirstResponder];
    
    if(!error){
    
        AppDelegate *ad = [AppDelegate sharedAppController];
        ad.playersNeedRefreshing = YES;
        
        //AppDelegate *ac = [AppDelegate sharedAppController];
        NSManagedObjectContext *moc/* = [ac managedObjectContext]*/;
    
        if (moc == nil) { 
            DLog(@"nil");
            moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
        
         DLog(@"%@", [[moc registeredObjects] description]);
        
        if(_player==nil){
            _player = (Player *)[NSEntityDescription insertNewObjectForEntityForName:@"Player"
                                                              inManagedObjectContext:moc];
        }
        
        _player.name = _tfName.text;
        
        if(_image!=nil){
            NSData *imageData = UIImagePNGRepresentation(_image);
            _player.photo = imageData;
        }else if(_ivPlayer.image==nil){
            NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"defaultUser.png"]);
            _player.photo = imageData;
        }
        
        NSError *mocerror;
        if (![moc save:&mocerror]) {
            NSLog(@"Whoops, couldn't save: %@", [mocerror localizedDescription]);
        }else{
            _changed=NO;
            
            [self rightButton];
            
            self.navigationItem.leftBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                          target: self
                                                          action: @selector(backButtonDidPressed:)]; 
            
            if(hud==nil){
                hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            }
            [self.navigationController.view addSubview:hud];
            
            // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
            // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
            //hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconWobble.png"]] autorelease];
            
            // Set custom view mode
            hud.mode = MBProgressHUDModeDeterminate;
            hud.animationType = MBProgressHUDAnimationZoom;
            hud.userInteractionEnabled=NO;
            
            hud.delegate = (id<MBProgressHUDDelegate>)self;
            hud.labelText = @"Saved";
            
            [hud show:YES];
            [hud hide:YES afterDelay:2];
            
            _forceSelect=YES;
            
            if(![_parent.chosenItems containsObject:_player]){
                [_parent.chosenItems addObject:_player];
                
                DLog(@"chosen %@ - %@", _parent.chosenItems, _player);
            }
        }
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoa..."
															message:@"You forgot to put a name!"
														   delegate:self
												  cancelButtonTitle:nil
												  otherButtonTitles:@"Ok", nil];
		
		[alertView show];
    }
}

- (void)backButtonDidPressed:(id)sender{
    DLog(@"~");
    
    if(_changed){
        // warn
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops!"
															message:@"Are you sure you want to leave without saving?"
														   delegate:self
												  cancelButtonTitle:@"Yes"
												  otherButtonTitles:@"Wait...", nil];
		alertView.tag=50;
		[alertView show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertView.tag==50){
        if(buttonIndex==alertView.cancelButtonIndex){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Open Camera

- (void)openCamera:(id)sender{
    DLog(@"~");
    
    [_tfName resignFirstResponder];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIActionSheet *actionSheet;
        
        if(_image!=nil){
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
        }else{
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
        }
		//[actionSheet setTag:1];
        
        actionSheet.tag=0;
        
		[actionSheet showInView:self.view];
        
        /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [actionSheet showInView:self.view];
        }else{
            [actionSheet showFromRect:_ivPlayer.frame inView:self.view animated:YES];
        }*/
        
        // broken
        
        /* picker = [[UIImagePickerController alloc] init];
         picker.sourceType = UIImagePickerControllerSourceTypeCamera;
         
         picker.delegate = self;
         //picker.allowsImageEditing = NO;
         
         [ac.blank presentModalViewController:picker animated:YES];
         [picker release];*/
	}
	else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		NSLog(@" ----- 2");
        
        
        
        if(_image!=nil){
            
            UIActionSheet *actionSheet;
            
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:@"Remove Image"
                                             otherButtonTitles:nil];
            
            actionSheet.tag=0;
            
            [actionSheet showInView:self.view];
            
            /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                [actionSheet showInView:self.view];
            }else{
                [actionSheet showFromRect:_ivPlayer.frame inView:self.view animated:YES];
            }*/
            
        }else{
            _picker = [[UIImagePickerController alloc] init];
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _picker.contentSizeForViewInPopover = CGSizeMake(320, 480);
            //_picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:_picker.sourceType];   
            _picker.delegate = self;
            _picker.allowsEditing=YES;
            //picker.allowsImageEditing = NO;
            
            // if iphone
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                [self.navigationController presentModalViewController:_picker animated:YES];
            }else{
            
                if([UINavigationBar conformsToProtocol:@protocol(UIAppearance)]){
                    [_picker.navigationBar setBackgroundImage:nil
                                            forBarMetrics:UIBarMetricsDefault];
                    [_picker.navigationBar setBackgroundImage:nil
                                            forBarMetrics:UIBarMetricsLandscapePhone];
                }
                
                // if ipad
                _popover = [[UIPopoverController alloc] initWithContentViewController:_picker];
                //self.popoverController = popover;          
                _popover.delegate = (id<UIPopoverControllerDelegate>)self;
                /*[self.popover presentPopoverFromRect:CGRectMake((self.view.frame.size.width/2), (self.view.frame.size.height/4), 100, 100)
                                                   inView:self.view
                                 permittedArrowDirections:UIPopoverArrowDirectionRight
                                                 animated:YES];*/
                
                DLog(@"1 %@", _ivPlayer);
                DLog(@"2 %@", _viewBG);
                DLog(@"3 %@", _popover);
                DLog(@"4 %@", _picker);
                
                [_popover presentPopoverFromRect:_ivPlayer.frame
                                              inView:_viewBG
                            permittedArrowDirections:UIPopoverArrowDirectionRight
                                            animated:YES];
                
                DLog(@"!");
            }
        }
        
		
	}
	else {
		NSLog(@" ----- 3");
		_picker = nil;
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Camera Found"
															message:@"You need an iPhone with a camera to use this application."
														   delegate:self
												  cancelButtonTitle:@"Cancel"
												  otherButtonTitles:@"Ok", nil];
		
		[alertView show];
	}
}

#pragma mark -
#pragma mark Image functions

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
	DLog(@"~");
    
    if(actionSheet.tag==0){
        
        //AppDelegate *ad = [AppDelegate sharedAppController];
        
        if (buttonIndex == actionSheet.destructiveButtonIndex) 
        {
            // Do something...
            
            _image = nil;
            _ivPlayer.image=nil;
            
            [self refreshImage];
            
        }else if((buttonIndex==1 && actionSheet.destructiveButtonIndex!=-1) || (buttonIndex==0 && actionSheet.destructiveButtonIndex==-1)){
            _picker = [[UIImagePickerController alloc] init];
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]; 
            _picker.allowsEditing=YES;
            _picker.delegate = (id<UIImagePickerControllerDelegate>)self;
            
            [self.navigationController presentModalViewController:_picker animated:YES];
            return;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                [self.navigationController presentModalViewController:_picker animated:YES];
            }else{
                
                if([UINavigationBar conformsToProtocol:@protocol(UIAppearance)]){
                    [_picker.navigationBar setBackgroundImage:nil
                                                forBarMetrics:UIBarMetricsDefault];
                    [_picker.navigationBar setBackgroundImage:nil
                                                forBarMetrics:UIBarMetricsLandscapePhone];
                }
                
                _popover = [[UIPopoverController alloc] initWithContentViewController:_picker];
                //self.popoverController = popover;          
                _popover.delegate = (id<UIPopoverControllerDelegate>)self;
                /*[self.popover presentPopoverFromRect:CGRectMake((self.view.frame.size.width/2), (self.view.frame.size.height/4), 100, 100)
                 inView:self.view
                 permittedArrowDirections:UIPopoverArrowDirectionRight
                 animated:YES];*/
                
                DLog(@"1 %@", _ivPlayer);
                DLog(@"2 %@", _viewBG);
                DLog(@"3 %@", _popover);
                
                [_popover presentPopoverFromRect:_ivPlayer.frame
                                          inView:_viewBG
                        permittedArrowDirections:UIPopoverArrowDirectionRight
                                        animated:YES];
            }
        }else if((buttonIndex==2 && actionSheet.destructiveButtonIndex!=-1) || (buttonIndex==1 && actionSheet.destructiveButtonIndex==-1)){
            _picker = [[UIImagePickerController alloc] init];
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:_picker.sourceType]; 
            _picker.delegate = (id<UIImagePickerControllerDelegate>)self;
            _picker.allowsEditing = YES;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                [self.navigationController presentModalViewController:_picker animated:YES];
            }else{
                if([UINavigationBar conformsToProtocol:@protocol(UIAppearance)]){
                    [_picker.navigationBar setBackgroundImage:nil
                                                forBarMetrics:UIBarMetricsDefault];
                    [_picker.navigationBar setBackgroundImage:nil
                                                forBarMetrics:UIBarMetricsLandscapePhone];
                }
                
                _popover = [[UIPopoverController alloc] initWithContentViewController:_picker];
                //self.popoverController = popover;          
                _popover.delegate = (id<UIPopoverControllerDelegate>)self;
                /*[self.popover presentPopoverFromRect:CGRectMake((self.view.frame.size.width/2), (self.view.frame.size.height/4), 100, 100)
                 inView:self.view
                 permittedArrowDirections:UIPopoverArrowDirectionRight
                 animated:YES];*/
                
                DLog(@"1 %@", _ivPlayer);
                DLog(@"2 %@", _viewBG);
                DLog(@"3 %@", _popover);
                
                [_popover presentPopoverFromRect:_ivPlayer.frame
                                          inView:_viewBG
                        permittedArrowDirections:UIPopoverArrowDirectionRight
                                        animated:YES];
            }
        }else if((buttonIndex==3 && actionSheet.destructiveButtonIndex!=-1) || (buttonIndex==2 && actionSheet.destructiveButtonIndex==-1)){
            
        }
        
    }/*else if(actionSheet.tag==100){
        if (buttonIndex == actionSheet.destructiveButtonIndex) 
        {
            [self requestDelete];
            
        }else if(buttonIndex==1){
            [self removeVideo];
        }else if(buttonIndex==2){
            [self editText];
        }else{
            [_touchedItem release];
            _touchedItem = nil;
        }
    }else if(actionSheet.tag==101){
        if (buttonIndex == actionSheet.destructiveButtonIndex) 
        {
            [self requestDelete];
            
        }else if(buttonIndex==1){
            [self removeImage];
        }else if(buttonIndex==2){
            [self editText];
        }else{
            [_touchedItem release];
            _touchedItem = nil;
        }
    }else if(actionSheet.tag==102){
        if (buttonIndex == actionSheet.destructiveButtonIndex) 
        {
            [self requestDelete];
            
        }else if(buttonIndex==1){
            [self takePhotoOrVideo];
        }else if(buttonIndex==2){
            [self chooseFromLibrary];
        }else if(buttonIndex==3){
            [self editText];
        }else{
            [_touchedItem release];
            _touchedItem = nil;
        }
    }else if(actionSheet.tag==103){
        if (buttonIndex == actionSheet.destructiveButtonIndex) 
        {
            [self requestDelete];
            
        }else if(buttonIndex==1){
            [self chooseFromLibrary];
        }else if(buttonIndex==2){
            [self editText];
        }else{
            [_touchedItem release];
            _touchedItem = nil;
        }
    }else if(actionSheet.tag==104){
        if (buttonIndex == actionSheet.destructiveButtonIndex) 
        {
            [self requestDelete];
            
        }else if(buttonIndex==1){
            [self editText];
        }else{
            [_touchedItem release];
            _touchedItem = nil;
        }
    }*/
}

- (void) imagePickerController: (UIImagePickerController *) imagePicker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    //NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //DLog(@"mediaType %@", mediaType);
	//if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
    
    _changed=YES;
    
    [self rightButton];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                  target: self
                                                  action: @selector(backButtonDidPressed:)]; 
        
    if([info objectForKey:UIImagePickerControllerEditedImage]!=nil){
    
        _image = [info objectForKey:UIImagePickerControllerEditedImage];
        
    }else{
        _image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    //}
    
    [self refreshImage];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }else{
        
        if(imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }else{
            [_popover dismissPopoverAnimated:YES];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePicker{
    DLog(@"~");
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }else{
        if(imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }else{
            [_popover dismissPopoverAnimated:YES];
        }
    }
}

-(NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskLandscape;
    else  /* iphone */
        return UIInterfaceOrientationMaskPortrait;
}

/*- (NSUInteger) supportedInterfaceOrientations
{
    DLog(@"~");
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)w {
    
    DLog(@"~");
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    
}*/

@end
