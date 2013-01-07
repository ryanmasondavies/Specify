//
//  BHVExample.m
//  Behave
//
//  Created by Ryan Davies on 30/12/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVExample.h"
#import "BHVContext.h"
#import "BHVHook.h"

@implementation BHVExample

- (id)init
{
    if (self = [super init]) {
        self.block = ^{};
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name block:(void(^)(void))block
{
    if (self = [self init]) {
        self.name = name;
        self.block = block;
    }
    return self;
}

- (void)execute
{
    // Create lists which will be populated during the search:
    NSMutableArray *beforeAllHooks  = [NSMutableArray array];
    NSMutableArray *beforeEachHooks = [NSMutableArray array];
    NSMutableArray *afterEachHooks  = [NSMutableArray array];
    NSMutableArray *afterAllHooks   = [NSMutableArray array];
    
    // Track whether all examples have been executed:
    __block BOOL allExamplesHaveBeenExecuted = YES;
    
    // Start at the direct parent and loop until `context` has no parent:
    BHVContext *context = [self parentContext];
    while (context != nil) {
        // Add context hooks to appropriate list:
        [[context hooks] enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) {
            switch ([hook flavor]) {
                case BHVHookScopeBeforeAll:  [beforeAllHooks  insertObject:hook atIndex:0]; break; // Shallowest-first order.
                case BHVHookScopeBeforeEach: [beforeEachHooks addObject:hook]; break;
                case BHVHookScopeAfterEach:  [afterEachHooks  addObject:hook]; break;
                case BHVHookScopeAfterAll:   [afterAllHooks   addObject:hook]; break;
            }
        }];
        
        // Check whether or not any examples in the context have been executed:
        [[context examples] enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
            // Ignore this example, as it hasn't been executed yet.
            if (example == self) return;
            
            // Mark whether or not all or any have been executed:
            if ([example isExecuted] == NO)
                allExamplesHaveBeenExecuted = NO;
        }];
        
        // Move to context's parent:
        context = [context parentContext];
    }
    
    // For each `beforeAll` hook, invoke only if no example in the hook's context has been executed:
    [beforeAllHooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) {
        __block BOOL anyExampleHasBeenExecuted = NO;
        [[[hook parentContext] examples] enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
            if ([example isExecuted]) {
                anyExampleHasBeenExecuted = YES;
            }
        }];
        
        if (anyExampleHasBeenExecuted == NO) {
            hook.block();
        }
    }];
    
    // Invoke blocks of all `before each` hooks:
    [beforeEachHooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) { hook.block(); }];
    
    // Invoke example:
    self.block();
    
    // Invoke blocks of all `after each` hooks:
    [afterEachHooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) { hook.block(); }];
    
    // Invoke blocks of all `after all` hooks if all examples have been executed:
    if (allExamplesHaveBeenExecuted) {
        [afterAllHooks enumerateObjectsUsingBlock:^(BHVHook *hook, NSUInteger idx, BOOL *stop) { hook.block(); }];
    }
    
    // Mark as executed:
    self.executed = YES;
}

@end
