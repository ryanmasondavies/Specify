//
//  BHVCompiler.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVCompiler.h"

@interface BHVCompiler ()
@property (nonatomic, strong) NSMutableArray *examples;
@end

@implementation BHVCompiler

+ (id)sharedCompiler
{
    static dispatch_once_t pred;
    static BHVCompiler *compiler = nil;
    dispatch_once(&pred, ^{ compiler = [[self alloc] init]; });
    return compiler;
}

- (id)init
{
    self = [super init];
    if (self) self.examples = [NSMutableArray array];
    return self;
}

- (void)compile:(BHVVoidBlock)block
{
    block();
    
    // Room for compilation.
    
    self.compiledExamples = [self examples];
}

- (void)addExample:(BHVExample *)example
{
    [[self examples] addObject:example];
}

@end
