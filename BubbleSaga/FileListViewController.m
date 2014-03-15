//
//  FileListViewController.m
//  BubbleSaga
//
//  Created by tangyixuan on 1/3/14.
//  Copyright (c) 2014 NUS CS3217. All rights reserved.
//

#import "FileListViewController.h"

@implementation FileListViewController

- (id) initWithDelegate:(id<LoadViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.fileNames = [[NSMutableArray alloc] init];
        NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.fileNames = (NSMutableArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
        self.delegate = delegate;
        self.fileCount = 0;
        self.view.frame = CGRectMake(POP_VIEW_START_WIDTH,POP_VIEW_START_HEIGHT,POP_VIEW_WIDTH,POP_VIEW_HEIGHT);
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]  forCellReuseIdentifier:@"FileNameCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section
{
    return [self.fileNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileNameCell" forIndexPath:indexPath];
    cell.textLabel.text = [self getMyTitleForRow:indexPath.row inSection: indexPath.section];
    return cell;
}

-(NSString *) getMyTitleForRow:(NSUInteger)row inSection:(NSUInteger)section{
    return [self.fileNames objectAtIndex:row];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate loadCorrespondingViewOfRow:(int)indexPath.row];
}

-(void) updateView{
    [self.tableView reloadData];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
