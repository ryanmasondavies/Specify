//
//  BHVSpec.h
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#define SpecBegin(className) \
@interface className##Spec : BHVSpec; @end \
@implementation className##Spec \
\
+ (NSArray *)examples \
{ \
    static NSMutableArray *examples = nil; \
    if (examples != nil) return examples; \
    \
    examples = [NSMutableArray array]; \
    void(^it)(NSString *name, void (^block)(void)) = ^(NSString *name, void (^block)(void)) { \
        BHVExample *example = [[BHVExample alloc] init]; \
        [example setBlock:block]; \
        [examples addObject:example]; \
    }; \

#define SpecEnd \
    return [NSArray arrayWithArray:examples]; \
} \
@end

@interface BHVSpec : SenTestCase
+ (NSArray *)examples;
@end
