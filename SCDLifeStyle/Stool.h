//
//  Stool.h
//  SCDLifeStyle
//
//  Created by Juan Fluxa on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stool : NSManagedObject

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSDate * time;

@end
