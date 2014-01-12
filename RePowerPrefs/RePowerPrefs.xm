//
//  RePowerPrefs.xm
//  RePower
//
//  Created by HASHBANG Productions on 10.01.2014.
//  Copyright (c) 2014 HASHBANG Productions. All rights reserved.
//

#import "../Headers/Preferences/PSListController.h"

@interface RePowerPrefsListController : PSListController
@end

@implementation RePowerPrefsListController

-(id)specifiers{
	if (!_specifiers)
		_specifiers = [self loadSpecifiersFromPlistName:@"RePowerPrefs" target:self];

	return _specifiers;
}
@end
