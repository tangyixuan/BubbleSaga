//
//  WelcomeViewController.m
//  BubbleSaga
//
//  Created by tangyixuan on 28/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()
@property (nonatomic) AVAudioPlayer *musicPlayer;
@property (nonatomic) BOOL isPlayingMusic;

- (IBAction)musicButtonPressed:(id)sender;

@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self playBackgroundMusic];
}

- (void)playBackgroundMusic
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"backgroudMusic" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundFileURL error:nil];
    self.musicPlayer.numberOfLoops = INFINITY;
    self.isPlayingMusic = YES;
    [self.musicPlayer play];
}

- (IBAction)musicButtonPressed:(id)sender
{
    if(self.isPlayingMusic){
        [self.musicPlayer stop];
        self.isPlayingMusic = NO;
        [sender setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.musicPlayer play];
        self.isPlayingMusic = YES;
        [sender setTitle:@"X" forState:UIControlStateNormal];
    }
}

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
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
