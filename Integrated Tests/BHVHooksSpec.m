//
//  BHVHooksSpec.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "Beehive.h"

@interface BHVThing : NSObject
@property (nonatomic, strong) NSMutableArray *widgets;
@end

@implementation BHVThing

- (id)init {
    if (self = [super init]) self.widgets = [NSMutableArray array];
    return self;
}

@end

SpecBegin(BHVBeforeEachSpec)

describe(@"thing", ^{
    __block BHVThing *thing;
    
    beforeEach(^{
        thing = [[BHVThing alloc] init];
    });
    
    describe(@"initialized in before(@\"each\"", ^{
        // TODO: [[[thing should] have:0] widgets];
        [[@([[thing widgets] count]) should] beEqualTo:@0];
    });
    
    it(@"can accept new widgets", ^{
        [[thing widgets] addObject:[NSObject new]];
    });
    
    it(@"does not share state across examples", ^{
        [[@([[thing widgets] count]) should] beEqualTo:@0];
    });
});

SpecEnd
