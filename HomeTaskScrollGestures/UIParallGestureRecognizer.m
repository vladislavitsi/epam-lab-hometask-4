//
//  UIParallGestureRecognizer.m
//  HomeTaskScrollGestures
//
//  Created by Владислав Клещенко on 4/2/18.
//  Copyright © 2018 vladislavitsi. All rights reserved.
//

#import "UIParallGestureRecognizer.h"

#define initialDistanceBetweenTouches 100

@interface UIParallGestureRecognizer ()

@property (nonatomic, strong) UITouch *touch1;
@property (nonatomic, strong) UITouch *touch2;

@property (nonatomic, assign) CGPoint startPoint1;
@property (nonatomic, assign) CGPoint startPoint2;
@property (nonatomic, assign) CGPoint currPoint1;
@property (nonatomic, assign) CGPoint currPoint2;

@property (nonatomic, assign) NSInteger touchesCounter;

- (void)saveFirstStateAndCheck:(NSArray<UITouch *> *)ts;
- (void)updateState;
- (BOOL)isOkDistanceBetweenTouches;
- (BOOL)checkFinalState;
- (void)resetState;
@end

@implementation UIParallGestureRecognizer

// BEGIN
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.touchesCounter != 2 && touches.count <= 2) {
        if (touches.count == 2) {
            [self saveFirstStateAndCheck:[touches allObjects]];
        } else if (touches.count == 1) {
            if (self.touchesCounter == 1){
                [self saveFirstStateAndCheck:@[self.touch1, [touches anyObject]]];
            } else if (self.touchesCounter == 0) {
                UITouch *touch = [touches anyObject];
                self.touch1 = touch;
                self.startPoint1 = [self.touch1 locationInView:self.view];
                self.currPoint1 = self.startPoint1;
                self.touchesCounter = 1;
            }
        }
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}


- (void)saveFirstStateAndCheck:(NSArray<UITouch *> *)touches {
    CGPoint p1 = [touches[0] locationInView:self.view];
    CGPoint p2 = [touches[1] locationInView:self.view];
    if (p2.y>p1.y) {
        self.startPoint1 = p1;
        self.startPoint2 = p2;
        self.touch1 = touches[0];
        self.touch2 = touches[1];
    }else {
        self.startPoint1 = p2;
        self.startPoint2 = p1;
        self.touch1 = touches[1];
        self.touch2 = touches[0];
    }
    self.currPoint1 = self.startPoint1;
    self.currPoint2 = self.startPoint2;
    self.touchesCounter = 2;
    if (![self isOkDistanceBetweenTouches]) {
        self.state = UIGestureRecognizerStateFailed;
    }
}


- (BOOL)isOkDistanceBetweenTouches {
    if ([self.touch2 locationInView:self.view].y - [self.touch1 locationInView:self.view].y >= initialDistanceBetweenTouches) {
        return YES;
    }
    return NO;
}


// MOVE
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.touchesCounter == 2) {
        [self updateState];
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)updateState {
    CGPoint newCurrPoint1 = [self.touch1 locationInView:self.view];
    CGPoint newCurrPoint2 = [self.touch2 locationInView:self.view];
    self.currPoint1 = newCurrPoint1;
    self.currPoint2 = newCurrPoint2;
}


// END
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.touchesCounter == 2) {
        if ([self checkFinalState]) {
            self.state = UIGestureRecognizerStateRecognized;
            return;
        }
    }
    self.state = UIGestureRecognizerStateFailed;
}

- (BOOL)checkFinalState {
//    final condition
    if (self.currPoint1.y >= self.startPoint2.y && self.currPoint2.y <= self.startPoint1.y) {
        return YES;
    }
    return NO;
}


// CANCEL
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
}

- (void)resetState {
    self.touch1 = nil;
    self.touch2 = nil;
    CGPoint nilPoint = {0, 0};
    self.startPoint1 = nilPoint;
    self.startPoint2 = nilPoint;
    self.currPoint1 = nilPoint;
    self.currPoint2 = nilPoint;
    self.touchesCounter = 0;
}

// RESET
- (void)reset {
    [super reset];
    [self resetState];
}

@end
