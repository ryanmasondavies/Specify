//
//  BHVItem.h
//  Beehive
//
//  Created by Ryan Davies on 21/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVBlockTypes.h"

@interface BHVItem : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) BHVImplementationBlock implementation;
@end
