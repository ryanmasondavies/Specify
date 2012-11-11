//
//  BHVCompiler.h
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVBlockTypes.h"

@class BHVExample;

@interface BHVCompiler : NSObject
@property (nonatomic, strong) NSArray *compiledExamples;

+ (id)sharedCompiler;

- (void)compile:(BHVVoidBlock)block;
- (void)addExample:(BHVExample *)example;

@end
