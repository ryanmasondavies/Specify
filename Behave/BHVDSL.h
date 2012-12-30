//
//  BHVDSL.h
//  Behave
//
//  Created by Ryan Davies on 30/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHVDSL : NSObject
@end

void it(NSString *name, void(^block)(void));
void context(NSString *name, void(^block)(void));
void describe(NSString *name, void(^block)(void));
void beforeEach(void(^block)(void));
void afterEach(void(^block)(void));
void beforeAll(void(^block)(void));
void afterAll(void(^block)(void));
