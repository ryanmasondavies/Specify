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
@property (nonatomic, copy) BHVVoidBlock block;

- (void)execute;

@end
