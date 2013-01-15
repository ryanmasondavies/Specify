//
//  BHVDSLTests.m
//  Behave
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

#import "BHVTestHelper.h"

// TODO: What we really need here is the ability to mock class methods.

@interface BHVMockSpecification : NSObject
@end

@implementation BHVMockSpecification

+ (BHVBuilder *)builder
{
    static id mock = nil;
    if (mock == nil) mock = [OCMockObject mockForClass:[BHVBuilder class]];
    return mock;
}

@end

#pragma mark -

@interface BHVDSLTests : SenTestCase
@end

@implementation BHVDSLTests

- (void)setUp
{
    [BHVSpecification setCurrentSpecification:[BHVMockSpecification class]];
}

- (void)test_It_CreatesAndAddsExample
{
    void(^implementation)(void) = ^{};
    
    id builder = [BHVMockSpecification builder];
    [[builder expect] addExample:[OCMArg checkWithBlock:^BOOL(id example) {
        return [[example name] isEqualToString:@"should work"] && [example block] == implementation;
    }]];
    
    it(@"should work", implementation);
    
    [builder verify];
}

- (void)test_Context_AddsExamplesInBlock
{
    void(^implementation)(void) = ^{
        it(@"should work with contexts", ^{});
    };
    
    id builder = [BHVMockSpecification builder];
    [[builder expect] enterGroup:[OCMArg checkWithBlock:^BOOL(id group) {
        return [[group name] isEqualToString:@"should work"];
    }]];
    [[builder expect] addExample:[OCMArg checkWithBlock:^BOOL(id example) {
        return [[example name] isEqualToString:@"should work with contexts"];
    }]];
    [[builder expect] leaveGroup];
    
    context(@"should work", implementation);
    
    [builder verify];
}

- (void)test_Describe_AddsExamplesInBlock
{
    void(^implementation)(void) = ^{
        it(@"should work with contexts", ^{});
    };
    
    id builder = [BHVMockSpecification builder];
    [[builder expect] enterGroup:[OCMArg checkWithBlock:^BOOL(id group) {
        return [[group name] isEqualToString:@"should work"];
    }]];
    [[builder expect] addExample:[OCMArg checkWithBlock:^BOOL(id example) {
        return [[example name] isEqualToString:@"should work with contexts"];
    }]];
    [[builder expect] leaveGroup];
    
    describe(@"should work", implementation);
    
    [builder verify];
}

- (void)test_When_AddsExamplesInBlock
{
    void(^implementation)(void) = ^{
        it(@"should work with contexts", ^{});
    };
    
    id builder = [BHVMockSpecification builder];
    [[builder expect] enterGroup:[OCMArg checkWithBlock:^BOOL(id group) {
        return [[group name] isEqualToString:@"when not dead"];
    }]];
    [[builder expect] addExample:[OCMArg checkWithBlock:^BOOL(id example) {
        return [[example name] isEqualToString:@"should work with contexts"];
    }]];
    [[builder expect] leaveGroup];
    
    when(@"not dead", implementation);
    
    [builder verify];
}

- (void)test_BeforeEach_AddsBeforeEachHook
{
    void(^implementation)(void) = ^{};
    
    id builder = [BHVMockSpecification builder];
    [[builder expect] addHook:[OCMArg checkWithBlock:^BOOL(id hook) {
        return [hook block] == implementation;
    }]];
    
    beforeEach(implementation);
    
    [builder verify];
}

- (void)test_Before_AddsBeforeEachHook
{
    void(^implementation)(void) = ^{};
    
    id builder = [BHVMockSpecification builder];
    [[builder expect] addHook:[OCMArg checkWithBlock:^BOOL(id hook) {
        return [hook block] == implementation;
    }]];
    
    before(implementation);
    
    [builder verify];
}

- (void)test_AfterEach_AddsAfterEachHook
{
    void(^implementation)(void) = ^{};
    
    id builder = [BHVMockSpecification builder];
    [[builder expect] addHook:[OCMArg checkWithBlock:^BOOL(id hook) {
        return [hook block] == implementation;
    }]];
    
    afterEach(implementation);
    
    [builder verify];
}

@end
