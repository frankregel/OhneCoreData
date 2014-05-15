//
//  ToDosTableViewController.m
//  OhneCoreData
//
//  Created by Frank Regel on 09.05.14.
//  Copyright (c) 2014 appanatics. All rights reserved.
//

#import "DataModel.h"
#import "ToDosTableViewController.h"
#import "TodoEditTableViewController.h"

@interface ToDosTableViewController ()

@end

@implementation ToDosTableViewController

- (void)viewDidLoad
{
    NSLogLine;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[DataModel sharedInstance]groups] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DataModel sharedInstance]todosAtGroup:section]count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[DataModel sharedInstance]groups] [section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLogLine;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSMutableDictionary *todo = [[DataModel sharedInstance]todoAtIndexPath:indexPath];
    
    
    // Configure the cell...
    cell.textLabel.text = [todo objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.tableView beginUpdates];
        NSMutableDictionary *todo = [[DataModel sharedInstance] todoAtIndexPath:indexPath];
        NSInteger indexOfSection = [[[DataModel sharedInstance]groups]indexOfObject:[todo valueForKey:@"group"]];
        NSInteger numberOfRows = [self.tableView numberOfRowsInSection:indexOfSection];
        
        [[DataModel sharedInstance]deleteTodo:todo];
        [[DataModel sharedInstance]save];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (numberOfRows == 1)
        {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexOfSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.tableView endUpdates];
    }
}

#pragma mark - Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"edit"])
    {
        TodoEditTableViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary *todo = [[DataModel sharedInstance]todoAtIndexPath:indexPath];
        controller.todo = todo;
        
    }
}
@end
