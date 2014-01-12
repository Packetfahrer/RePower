#define PREFERENCES 1

NSBundle *prefsBundle;

#define IN_SPRINGBOARD (SPRINGBOARD || [[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"])
#define I18N(key) ([prefsBundle localizedStringForKey:key value:key table:@"TypeStatus"])
#define GET_BOOL(key, default) (prefs[key] ? ((NSNumber *)prefs[key]).boolValue : default)
#define GET_FLOAT(key, default) (prefs[key] ? ((NSNumber *)prefs[key]).floatValue : default)

#import "HBTSAboutListController.h"
#import <MobileGestalt/MobileGestalt.h>
#include <version.h>

NSString *HBTSOutputForShellCommand(NSString *command) {
	FILE *file = popen(command.UTF8String, "r");

	if (!file) {
		return nil;
	}

	char data[1024];
	NSMutableString *output = [NSMutableString string];

	while (fgets(data, 1024, file) != NULL) {
		[output appendString:[NSString stringWithUTF8String:data]];
	}

	if (pclose(file) != 0) {
		return nil;
	}

	return [NSString stringWithString:output];
}

@implementation HBTSAboutListController

#pragma mark - PSListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"About" target:self];
	}

	return _specifiers;
}

#pragma mark - Callbacks

- (void)openWebsite {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://hbang.ws"]];
}

- (void)openDonate {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://hbang.ws/donate"]];
}

- (void)sendSupportEmail {
	if (![MFMailComposeViewController canSendMail]) {
		if (!prefsBundle) {
			prefsBundle = [NSBundle bundleForClass:self.class];
		}

		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:I18N(@"No mail accounts are set up.") message:I18N(@"Use the Mail settings to add a new account.") delegate:nil cancelButtonTitle:I18N(@"OK") otherButtonTitles:nil];
		[alertView show];

		return;
	}

	MFMailComposeViewController *viewController = [[MFMailComposeViewController alloc] init];
	viewController.mailComposeDelegate = self;
	viewController.toRecipients = @[ @"HASHBANG Productions Support <support@hbang.ws>" ];
	viewController.subject = [NSString stringWithFormat:@"RePower %@ Support", HBTSOutputForShellCommand(@"/usr/bin/dpkg-query -f '${Version}' -W ws.hbang.repower")];
	[viewController addAttachmentData:[HBTSOutputForShellCommand(@"/usr/bin/dpkg -l") dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/plain" fileName:@"dpkgl.txt"];

	if (IS_IOS_OR_NEWER(iOS_6_0)) {
		[viewController setMessageBody:[NSString stringWithFormat:@"\n\nDevice information: %@, iOS %@ (%@)", MGCopyAnswer(kMGProductType), MGCopyAnswer(kMGProductVersion), MGCopyAnswer(kMGBuildVersion)] isHTML:NO];
	} else {
		[viewController setMessageBody:@"\n\nDevice information: iOS 5" isHTML:NO];
	}

	[self.navigationController presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)viewController didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
