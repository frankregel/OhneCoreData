//
//  TodoEditTableViewController.m
//  OhneCoreData
//
//  Created by Frank Regel on 12.05.14.
//  Copyright (c) 2014 appanatics. All rights reserved.
//
#import "DataModel.h"
#import "TodoEditTableViewController.h"

@interface TodoEditTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *groupTextFieldOutlet;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFieldOutlet;

@end

@implementation TodoEditTableViewController

- (IBAction)save:(id)sender
{
    NSLogLine;
    if (!self.todo)
    {
        self.todo = [NSMutableDictionary new];
        [[DataModel sharedInstance] addTodo:self.todo];
        
    }
    //auf empty prüfen
    [self.todo setObject:self.groupTextFieldOutlet.text forKey:@"group"];
    [self.todo setObject:self.nameTextFieldOutlet.text forKey:@"name"];
    
    [[DataModel sharedInstance] sort];
    [[DataModel sharedInstance] save];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad
{
    NSLogLine;
    [super viewDidLoad];
    
    
    
    if (self.todo)
    {
        self.groupTextFieldOutlet.text = [self.todo objectForKey:@"group"];
        self.nameTextFieldOutlet.text = [self.todo objectForKey:@"name"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
