//
//  RePower.m
//  RePower
//
//  Created by HASHBANG Productions on 10.01.2014.
//  Copyright (c) 2014 HASHBANG Productions. All rights reserved.
//

#import "RePower.h"

@implementation RePowerListController

- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"RePower" target:self];
	}
	return _specifiers;
}
@end
