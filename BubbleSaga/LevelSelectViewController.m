//
//  LevelSelectViewController.m
//  BubbleSaga
//
//  Created by tangyixuan on 28/2/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "LevelSelectViewController.h"

@interface LevelSelectViewController (){
    NSMutableArray *preallocateViews;
    NSMutableArray *designViews;
}

@property (nonatomic) NSUInteger indexSelected;
@property (nonatomic) NSMutableArray  *fileNames;

@end

@implementation LevelSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self setPreAllocateViews];
    [self setDesignViews];
    self.indexSelected = DEFAULT_FILE_INDEX;
}

-(void) setPreAllocateViews
{
    preallocateViews =  [[NSMutableArray alloc]init];
    CGSize imageSize = CGSizeMake(LEVEL_VIEW_WIDTH, LEVEL_VIEW_LENGTH);
    for (int index = 0; index < DEFAULT_FILE_NUM; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"default-level-%d.png",index]];
        UIImage *newImage = [UIImage imageWithImage:image scaledToSize:imageSize];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:newImage];
        [preallocateViews addObject:imageView];
    }
}

-(void) setDesignViews
{
    designViews = [[NSMutableArray alloc]init];
    CGSize imageSize = CGSizeMake(LEVEL_VIEW_WIDTH, LEVEL_VIEW_LENGTH);
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.fileNames = (NSMutableArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
    NSString *fileName;
    for (int index = 0; index < [self.fileNames count]; index++) {
        fileName = [self.fileNames objectAtIndex:index];
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
        NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSData *imageData = [unarchiver decodeObjectForKey:@"image"];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *newImage = [UIImage imageWithImage:image scaledToSize:imageSize];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:newImage];
        [designViews addObject:imageView];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSData *data;
    if (self.indexSelected < DEFAULT_FILE_NUM) {
        BubbleCollection *bubbleCollection = [[BubbleCollection alloc]initWithDelegate:nil];
        [bubbleCollection fillBubbleCollectionLevel:self.indexSelected];
        data = [bubbleCollection encodeWithImage: nil];
    }else{
        NSString *fileName = [self.fileNames objectAtIndex:(self.indexSelected - DEFAULT_FILE_NUM)];
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
        data = [[NSMutableData alloc]initWithContentsOfFile:filePath];
    }
    GamePlayViewController *controller = (GamePlayViewController *)segue.destinationViewController;
    controller.passInData = data;
}

- (int)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(int)section
{
    if(section == 0){
        return [preallocateViews count];
    }else{
        return [designViews count];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Screenshot Cell" forIndexPath:indexPath];
    collectionView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0];
    if (indexPath.section == 0) {
        cell.backgroundView = [preallocateViews objectAtIndex:indexPath.row];
    }else{
        cell.backgroundView = [designViews objectAtIndex:indexPath.row];
    }
    [cell.layer setCornerRadius:10.0];
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:[UIColor blackColor].CGColor];
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.indexSelected = indexPath.row;
    }else if(indexPath.section == 1){
        self.indexSelected = indexPath.row + DEFAULT_FILE_NUM;
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

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
