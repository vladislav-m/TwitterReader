//
//  UIViewController+ErrorAlert.m
//  TwitterReader
//
//  Created by Vladislav Myakotin on 26.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import "UIViewController+ErrorAlert.h"

@implementation UIViewController (ErrorAlert)

-(void)showErrorAlert:(NSString*)errorMessage
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
