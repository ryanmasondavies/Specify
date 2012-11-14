//
//  BHVExpectation.h
//  Beehive
//
//  Created by Ryan Davies on 14/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

@class BHVEqualityMatcher;

@interface BHVExpectation : NSObject

@property (nonatomic, strong) id subject;
@property (nonatomic, strong) NSInvocation *invocation;

- (id)initWithSubject:(id)subject;
- (void)verify;

@end

@interface BHVEqualityMatcher : NSObject
@property (nonatomic, strong) id subject;

- (id)initWithSubject:(id)subject;
- (BOOL)beEqualTo:(id)object;

@end
