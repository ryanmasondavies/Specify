//
//  BHVSuiteRegistry.m
//  Beehive
//
//  Created by Ryan Davies on 13/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuiteRegistry.h"
#import "BHVSuite.h"

@interface BHVSuiteRegistry ()
@property (nonatomic, strong) NSMutableDictionary *suitesByClasses;
@end

@implementation BHVSuiteRegistry

+ (id)sharedRegistry
{
    static dispatch_once_t pred;
    static BHVSuiteRegistry *registry = nil;
    dispatch_once(&pred, ^{ registry = [[self alloc] init]; });
    return registry;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.suitesByClasses = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)registerSuite:(BHVSuite *)suite forClass:(Class)klass
{
    [[self suitesByClasses] setObject:suite forKey:NSStringFromClass(klass)];
}

- (id)suiteForClass:(Class)klass
{
    return [[self suitesByClasses] objectForKey:NSStringFromClass(klass)];
}

@end
