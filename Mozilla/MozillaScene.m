// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@import SpriteKit;

#import "MozillaScene.h"

CGFloat RandomScaleFactor() {
    u_int32_t r = random() % 1000;
    if (r > 900) {
        return 0.5; // * (isPreview ? PreviewScaleFactor : 1.0);
    } else if (r > 450) {
        return 0.125; // * (isPreview ? PreviewScaleFactor : 1.0);
    } else {
        return 0.25; // * (isPreview ? PreviewScaleFactor : 1.0);
    }
}

CGSize RandomSize() {
    u_int32_t r = random() % 100;
    if (r < 75) {
        return CGSizeMake(64, 64);
    }
    return CGSizeMake(96, 96);
}

CGFloat RandomAngularVelocity() {
    CGFloat v = -35.0 + (random() % 70);
    return v / 100.0;
}

CGVector RandomVelocity() {
    return CGVectorMake(-250 + (random() % 500), -50 + (random() % 100));
}

NSString *RandomIconName() {
    switch (random() % 4) {
        case 0:
            return @"firefox-logo";
            break;
        case 1:
            return @"firefox-logo-focus";
            break;
        case 2:
            return @"firefox-logo-nightly";
            break;
        case 3:
            return @"firefox-logo-developer-edition";
            break;
    }
    return @"firefox-logo";
}

@implementation MozillaScene

- (id) initWithSize:(CGSize)size isPreview: (BOOL) isPreview {
    if (self = [super initWithSize: size]) {
        _isPreview = isPreview;
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView: view];

    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: NSInsetRect(self.frame, -200, -200)];
    self.physicsBody.categoryBitMask = 0x01;
    self.physicsWorld.contactDelegate = self;

    self.backgroundColor = NSColor.blackColor;

    self.logo = [SKSpriteNode spriteNodeWithImageNamed: [[NSBundle bundleForClass: [self class]] pathForImageResource: @"mozilla"]];
    if (self.logo != nil) {
        self.logo.position = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);

        CGFloat offsetX = self.logo.frame.size.width * self.logo.anchorPoint.x;
        CGFloat offsetY = self.logo.frame.size.height * self.logo.anchorPoint.y;

        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 3 - offsetX, 103 - offsetY);
        CGPathAddLineToPoint(path, NULL, 479 - offsetX, 96 - offsetY);
        CGPathAddLineToPoint(path, NULL, 496 - offsetX, 146 - offsetY);
        CGPathAddLineToPoint(path, NULL, 577 - offsetX, 146 - offsetY);
        CGPathAddLineToPoint(path, NULL, 568 - offsetX, 95 - offsetY);
        CGPathAddLineToPoint(path, NULL, 631 - offsetX, 100 - offsetY);
        CGPathAddLineToPoint(path, NULL, 661 - offsetX, 87 - offsetY);
        CGPathAddLineToPoint(path, NULL, 664 - offsetX, 63 - offsetY);
        CGPathAddLineToPoint(path, NULL, 673 - offsetX, 5 - offsetY);
        CGPathAddLineToPoint(path, NULL, 3 - offsetX, 1 - offsetY);
        CGPathCloseSubpath(path);

        self.logo.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath: path];
        //logo.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath: path]; Gives odd results - maybe the path is incorrect?
        self.logo.physicsBody.dynamic = NO;
        self.logo.physicsBody.density = 10.0;
        self.logo.physicsBody.mass = 1000;

        [self addChild: self.logo];
    }

    SKAction *createIconAction = [SKAction runBlock:^{
        SKSpriteNode *icon = [SKSpriteNode spriteNodeWithImageNamed: [[NSBundle bundleForClass: [self class]] pathForImageResource: RandomIconName()]];
        icon.position = CGPointMake(random() % (u_int32_t) CGRectGetWidth(self.frame), 700);
        icon.size = RandomSize();
        icon.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: icon.size.width / 2];
        icon.physicsBody.dynamic = YES;
        icon.physicsBody.restitution = 0.33;
        icon.physicsBody.angularDamping = 0.5;
        icon.physicsBody.friction = 0.5;
        icon.physicsBody.density = 2.5;
        icon.physicsBody.angularVelocity = RandomAngularVelocity();
        icon.physicsBody.velocity = RandomVelocity();
        icon.physicsBody.categoryBitMask = 0x02;
        icon.physicsBody.contactTestBitMask = 0x01;
        [self addChild: icon];
    }];

    SKAction *loopAction = [SKAction sequence: @[[SKAction waitForDuration: 0.25], createIconAction]];

    [self runAction: [SKAction repeatActionForever: loopAction]];

    //

    SKAction *sequence = [SKAction sequence: @[[SKAction waitForDuration: 5.0], [SKAction runBlock:^{
        if (self.scene.children.count >= 20) {
            SKAction *rotate = [SKAction rotateByAngle: 2*3.14 * (random() % 2 ? 1 : -1) duration: 5.0];
            rotate.timingMode = SKActionTimingEaseInEaseOut;
            [self.logo runAction: rotate];
        }
    }]]];
    [self runAction: [SKAction repeatActionForever: sequence]];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    if (contact.bodyA.categoryBitMask == 0x02 && contact.bodyB.categoryBitMask == 0x01) {
        [contact.bodyA.node removeFromParent];
    }
    if (contact.bodyB.categoryBitMask == 0x02  && contact.bodyA.categoryBitMask == 0x01) {
        [contact.bodyB.node removeFromParent];
    }
}

@end
