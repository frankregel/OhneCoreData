//
//  DataModel.h
//  OhneCoreData
//
//  Created by Frank Regel on 09.05.14.
//  Copyright (c) 2014 appanatics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
+ (DataModel *) sharedInstance;

- (NSInteger) numberOfTodos;
- (NSMutableDictionary *) todoAtIndexPath: (NSIndexPath *) indexPath;
- (void) addTodo: (NSMutableDictionary *) todo;
- (void) deleteTodo: (NSMutableDictionary *) todo;
- (void) save;
- (void) sort;

@end
