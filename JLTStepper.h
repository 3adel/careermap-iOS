#import <UIKit/UIKit.h>

typedef enum JLTStepperPlusMinusState_ {
    JLTStepperMinus = -1,
    JLTStepperPlus  = 1,
    JLTStepperUnset = 0
} JLTStepperPlusMinusState;

@interface JLTStepper : UIStepper
@property (nonatomic) JLTStepperPlusMinusState plusMinusState;
@end
