//
//  Stack.h
//  ps04
//
//  Created by Tang Yixuan on 2/16/14.
//
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject

// Class method which creates and returns an empty stack.
+ (Stack *)stack;

// Pushes an object to the top of the stack.
- (void)push:(id)obj;

// Pops an object from the top of the stack.
// If the queue is empty, returns `nil'.
- (id)pop;

// Returns, but does not remove, the object at the top of the stack.
// If the queue is empty, returns `nil'.
- (id)peek;

// Returns the number of objects currently in the stack.
- (NSUInteger)count;

// Removes all objects from the stack.
- (void)removeAllObjects;

@end
