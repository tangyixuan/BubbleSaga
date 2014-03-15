//
//  Stack.m
//  ps04
//
//  Created by Tang Yixuan on 2/16/14.
//
//

#import "Stack.h"

@interface Stack()

@property (strong, nonatomic) NSMutableArray *myArray;

@end

@implementation Stack

+ (Stack *)stack {
    return [[Stack alloc] init];
}

- (id)init {
    // TODO
    if ((self = [super init])) {
        self.myArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)push:(id)obj {
    // TODO
    [self.myArray addObject:obj];
}

- (id)pop {
    // TODO
    id obj = nil;
    if([self.myArray count] > 0){
        obj=[self.myArray lastObject];
        [self.myArray removeLastObject];
    }
    return obj;
}

- (id)peek {
    // TODO
    id obj = nil;
    if([self.myArray count] > 0){
        obj=[self.myArray lastObject];
    }
    return obj;
}

- (NSUInteger)count {
    // TODO
    return [self.myArray count];
}

- (void)removeAllObjects {
    // TODO
    [self.myArray removeAllObjects];
}

@end
