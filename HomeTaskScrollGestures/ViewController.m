//
//  ViewController.m
//  HomeTaskScrollGestures
//
//  Created by Владислав Клещенко on 4/2/18.
//  Copyright © 2018 vladislavitsi. All rights reserved.
//

#import "ViewController.h"
#import "UIParallGestureRecognizer.h"

#define keyboardBottomInset 220

@interface ViewController() <UITextFieldDelegate>

@property (strong, nonatomic) NSArray<UITextField*> *textFields;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *nickField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UITextField *rePassField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add TapGestureRecognizer for hidding keyboard.
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    // Add ParallGestureRecognizer that was custom implemented.
    UIParallGestureRecognizer *customGesture = [[UIParallGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomGesture)];
    [self.view addGestureRecognizer:customGesture];
    
    self.textFields = [NSArray arrayWithObjects:
                       self.nameField,
                       self.nickField,
                       self.emailField,
                       self.phoneField,
                       self.passField,
                       self.rePassField, nil];
    for (UITextField *textField in self.textFields) {
        textField.delegate = self;
    }
    
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

#pragma mark TextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardBottomInset, 0);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger n = [self.textFields indexOfObject:textField];
    if (n != NSNotFound) {
        [textField resignFirstResponder];
        if (n != self.textFields.count-1) {
            [self.textFields[n+1] becomeFirstResponder];
        } else{
            [self submit];
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark Action methods

// On submit button
- (void)submit {
    NSLog(@"Submit");
}

- (void)onTap {
    [self.view endEditing:YES];
}

- (void)onCustomGesture {
    NSLog(@"Gesture recognized");
}

@end
