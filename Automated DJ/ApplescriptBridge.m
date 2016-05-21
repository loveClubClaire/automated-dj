//
//  ApplescriptBridge.m
//  Now Playing in iTunes
//
//  Created by Zachary Whitten on 4/11/16.
//  Copyright © 2016 WCNURadio. All rights reserved.
//

#import "ApplescriptBridge.h"


@implementation ApplescriptBridge



-(id)init{
    Class myClass = NSClassFromString(@"MyApplescript");
    _myInstance = [[myClass alloc] init];
    return self;
}

-(void) iTunesPause{
    [_myInstance iTunesPause];
}

@end
