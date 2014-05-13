//
//  DataModel.m
//  OhneCoreData
//
//  Created by Frank Regel on 09.05.14.
//  Copyright (c) 2014 appanatics. All rights reserved.
//

#import "DataModel.h"

@interface DataModel ()
@property (nonatomic, strong) NSMutableArray *todos;

@end

@implementation DataModel

+ (DataModel *) sharedInstance
{
    static DataModel *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DataModel new];
    });
    return sharedInstance;
}

- (id) init
{
    if (!(self = [super init])) return nil;
    self.todos = [[NSUserDefaults standardUserDefaults]objectForKey:@"todos"];
    if (!self.todos)
    {
        self.todos = [NSMutableArray new];
        [self.todos addObject:[@{@"group" : @"Lebensmittel", @"name" : @"Eier"} mutableCopy]];
        [self.todos addObject:[@{@"group" : @"Lebensmittel", @"name" : @"Butter"} mutableCopy]];
        [self.todos addObject:[@{@"group" : @"Lebensmittel", @"name" : @"Milch"} mutableCopy]];
        [self.todos addObject:[@{@"group" : @"Lebensmittel", @"name" : @"Brot"} mutableCopy]];
        [self.todos addObject:[@{@"group" : @"Beruf", @"name" : @"Schwätzer"} mutableCopy]];
    }
    return self;
}

- (NSInteger) numberOfTodos
{
    return self.todos.count;
}

- (NSMutableDictionary *) todoAtIndexPath: (NSIndexPath *) indexPath
{
    return [self todosAtGroup:indexPath.section][indexPath.row];
    
}

- (NSArray *)groups
{
    NSArray *groups = [self.todos valueForKeyPath:@"@distinctUnionOfObjects.group"];
    return [groups sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
}

- (NSArray *)todosAtGroup: (NSInteger) group
{
    NSString *groupName = self.groups [group];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.group == %@", groupName];
    NSSortDescriptor *sortName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *todos = [self.todos filteredArrayUsingPredicate:predicate];
    return [todos sortedArrayUsingDescriptors:@[sortName]];
    
}

- (void) addTodo: (NSMutableDictionary *) todo
{
    [self.todos addObject:todo];
}

- (void) deleteTodo: (NSMutableDictionary *) todo
{
    [self.todos removeObject:todo];
}

- (void) save
{
    [[NSUserDefaults standardUserDefaults] setObject:self.todos forKey:@"todos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) sort
{
    NSSortDescriptor *sortGroup = [NSSortDescriptor sortDescriptorWithKey:@"group" ascending:YES];
    NSSortDescriptor *sortName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    [self.todos sortUsingDescriptors:@[sortGroup, sortName]];
    
    
}

@end
