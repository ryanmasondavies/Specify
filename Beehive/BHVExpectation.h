//
//  BHVExpectation.h
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

@class BHVMatcher;

@interface BHVExpectation : NSObject
@property (nonatomic, strong) id subject;
@property (nonatomic, strong) NSInvocation *invocation;
@property (nonatomic, strong) BHVMatcher *matcher;
@property (nonatomic, getter=isNegated) BOOL negated;

- (id)initWithSubject:(id)subject;
- (void)verify;

@end
