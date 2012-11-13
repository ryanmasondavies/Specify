//
//  BHVExample.h
//  Beehive
//
//  Created by Ryan Davies on 10/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVBlockTypes.h"

@interface BHVExample : NSObject
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) BHVVoidBlock implementation;

+ (id)exampleWithDescription:(NSString *)description implementation:(BHVVoidBlock)implementation;
- (id)initWithDescription:(NSString *)description implementation:(BHVVoidBlock)implementation;

- (void)execute;

@end
