//
//  GameDesignViewController.m
//  BubbleSaga
//
//  Created by tangyixuan on 28/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "GameDesignViewController.h"

@interface GameDesignViewController ()

@property (weak, nonatomic) IBOutlet UIView *gameArea;
@property (weak, nonatomic) IBOutlet UIView *palette;

@property (weak, nonatomic) IBOutlet UIButton *bubbleBlue;
@property (weak, nonatomic) IBOutlet UIButton *bubbleRed;
@property (weak, nonatomic) IBOutlet UIButton *bubbleGreen;
@property (weak, nonatomic) IBOutlet UIButton *bubbleOrange;
@property (weak, nonatomic) IBOutlet UIButton *specialBubbleIndestructible;
@property (weak, nonatomic) IBOutlet UIButton *specialBubbleLightning;
@property (weak, nonatomic) IBOutlet UIButton *specialBubbleBomb;
@property (weak, nonatomic) IBOutlet UIButton *specialBubbleStar;
@property (weak, nonatomic) IBOutlet UIButton *eraser;

@property (nonatomic) BubbleCollection *bubbleCollection;
@property (nonatomic) NSArray *paletteItems;
@property (nonatomic) NSUInteger toolChosen;
@property (nonatomic) FileListViewController *fileList;
@property (nonatomic) UIPopoverController *popViewForLoad;

- (IBAction)chooseTool:(id)sender;
- (IBAction)loadButtonPressed:(id)sender;
- (IBAction)SaveButtonPressed:(id)sender;
- (IBAction)ResetButtonPressed:(id)sender;

@end

@implementation GameDesignViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setbackGround
    [self.navigationController setNavigationBarHidden:NO];
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:backgroundImage];
    CGFloat gameViewHeight = self.gameArea.frame.size.height;
    CGFloat gameViewWidth = self.gameArea.frame.size.width;
    backgroundView.frame = CGRectMake(0,0,gameViewWidth,gameViewHeight);
    [self.gameArea addSubview:backgroundView];
    
    //set palette
    self.paletteItems = [NSArray arrayWithObjects: self.bubbleBlue,self.bubbleRed,self.bubbleGreen,self.bubbleOrange,self.specialBubbleIndestructible,self.specialBubbleLightning,self.specialBubbleBomb,self.specialBubbleStar,self.eraser, nil];
    [self setPaletteItemsTransparent];
    self.palette.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    self.palette.layer.zPosition = 3;
    
    self.bubbleCollection = [[BubbleCollection alloc]initWithDelegate:self];
    [self.bubbleCollection drawGrid];
    [self.bubbleCollection fillBubbleCollectionWithTransparentBubbles];
    
    self.fileList = [[FileListViewController alloc]initWithDelegate:self];
    
    //set testures
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.gameArea addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longpressGesture =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressHandler:)];
    [self.gameArea addGestureRecognizer:longpressGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    [self.gameArea addGestureRecognizer:panGesture];
}

- (void)setPaletteItemsTransparent
{
    UIButton *obj;
    for(obj in self.paletteItems){
        obj.alpha = 0.55;
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    [super viewWillDisappear:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Design To Play"]) {
        UIImage *capturedImage = [self screenShot];
        NSData *data = [self.bubbleCollection encodeWithImage: capturedImage];
        GamePlayViewController* controller = (GamePlayViewController *)segue.destinationViewController;
        controller.passInData = data;
    }
}

- (void)tapHandler:(UIGestureRecognizer *)gesture
{
    CGPoint position = [gesture locationInView:gesture.view];
    if (position.y < DESIGN_BOTTOM_BOUNDARY) {
        [self.bubbleCollection switchBubbleColorAtPosition:position];
    }
}

- (void)longpressHandler:(UIGestureRecognizer *)gesture
{
    CGPoint position = [gesture locationInView:gesture.view];
    if (position.y < DESIGN_BOTTOM_BOUNDARY) {
        GameBubble *newBubble = [[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:self];
        [self.bubbleCollection addBubble:newBubble atPosition:position];
    }
}

- (void)panHandler:(UIGestureRecognizer *)gesture
{
    CGPoint position = [gesture locationInView:gesture.view];
    if (position.y < DESIGN_BOTTOM_BOUNDARY) {
        GameBubble *newBubble = [self createBubbleOfType:self.toolChosen];
        [self.bubbleCollection addBubble:newBubble atPosition:position];
    }
}

- (GameBubble *)createBubbleOfType:(NSUInteger)toolIndex
{
    GameBubble *newBubble;
    switch (toolIndex) {
        case BLUE:
            newBubble = [[GameBubbleBasic alloc]initWithColor:BLUE andDelegate:self];
            break;
        case RED:
            newBubble = [[GameBubbleBasic alloc]initWithColor:RED andDelegate:self];
            break;
        case GREEN:
            newBubble = [[GameBubbleBasic alloc]initWithColor:GREEN andDelegate:self];
            break;
        case ORANGE:
            newBubble = [[GameBubbleBasic alloc]initWithColor:ORANGE andDelegate:self];
            break;
        case BUBBLE_INDESTRUCTIBLE:
            newBubble = [[GameBubbleIndestructible alloc]initWithDelegate:self];
            break;
        case BUBBLE_LIGHTENING:
            newBubble = [[GameBubbleLightening alloc]initWithDelegate:self];
            break;
        case BUBBLE_BOMB:
            newBubble = [[GameBubbleBomb alloc]initWithDelegate:self];
            break;
        case BUBBLE_STAR:
            newBubble = [[GameBubbleStar alloc]initWithDelegate:self];
            break;
        case ERASER:
            newBubble = [[GameBubbleBasic alloc]initWithColor:TRANSPARENT andDelegate:self];
            break;
        default:
            NSLog(@"invalid tool chosen");
            break;
    }
    return newBubble;
}

- (IBAction)chooseTool:(id)sender {
    [self setPaletteItemsTransparent];
    UIButton *tool = (UIButton*) sender;
    tool.alpha = 1;
    self.toolChosen = [self.paletteItems indexOfObject:tool];
}

- (IBAction)ResetButtonPressed:(id)sender {
    
    [self.bubbleCollection clear];
}

- (IBAction)SaveButtonPressed:(id)sender {
    UIAlertView *saveAlertView = [[UIAlertView alloc] initWithTitle:@"Save as:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [saveAlertView addButtonWithTitle:@"Save"];
    saveAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [saveAlertView show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(int)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        NSString *fileName;
        
        if([textfield isEqual:@""]){
            fileName = [NSString stringWithFormat:@"Game File %d", self.fileList.fileCount];
        }else{
            fileName = textfield.text;
        }
        
        if([self.fileList.fileNames count] == 0){
            [self.fileList.fileNames addObject:fileName];
        }else{
            [self.fileList.fileNames insertObject:fileName atIndex:0];
        }
        [self saveToFile];
    }
}

-(void) saveToFile{
    UIImage *capturedImage = [self screenShot];
    NSData *data = [self.bubbleCollection encodeWithImage: capturedImage];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[self.fileList.fileNames objectAtIndex:0]];
    
    BOOL success = [data writeToFile: filePath atomically:YES];
    if(!success){
        NSLog(@"Fail to save.");
    }else{
        self.fileList.fileCount ++;
    }
}

-(UIImage *)screenShot{
    CGRect rect = CGRectMake(0, DESIGN_SCREEN_TOP, SCREENWIDTH, DESIGN_SCREEN_LENGTH);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.gameArea.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedImage;
}

- (IBAction)loadButtonPressed:(id)sender
{
    [self.fileList updateView];
    self.popViewForLoad = [[UIPopoverController alloc]initWithContentViewController:self.fileList];
    [self.popViewForLoad presentPopoverFromRect:CGRectMake(POP_VIEW_START_WIDTH, POP_VIEW_START_HEIGHT,POP_VIEW_WIDTH, POP_VIEW_HEIGHT) inView:self.gameArea permittedArrowDirections:0 animated:NO];
}

//delegate method
-(void) loadCorrespondingViewOfRow:(int)row
{
    [self.popViewForLoad dismissPopoverAnimated:YES];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[self.fileList.fileNames objectAtIndex:row]];
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:filePath];
    [self.bubbleCollection resetWithData:data];
}

//delegate function
- (void)updateView:(UIView *)view
{
    if ([view superview]) {
        [view removeFromSuperview];
    }
    
    view.layer.zPosition = 1;
    [self.gameArea addSubview:view];
    [self.gameArea bringSubviewToFront:view];
}

//delegate function
- (void)removeView:(UIView *)view
{
    [view removeFromSuperview];
}

//delegate function
- (void)addView:(UIView *)view
{
    [self.gameArea addSubview:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//delegate methods
- (void)setLunchingBubbleView{}

- (void)showGameFailedView{}

- (void)showGameWonView{}

- (void)setCannonImageOfIndex:(NSUInteger)index{}

- (void)setScoreValue{}

@end
