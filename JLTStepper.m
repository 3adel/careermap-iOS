#import "JLTStepper.h"
//this class will help identify which stepper button is tapped. The + button on the minus button


@implementation JLTStepper
- (void)setValue:(double)value
{
    BOOL isPlus  = self.value < value;
    BOOL isMinus = self.value > value;
    
    if (self.wraps) { // Handing wrapped values is tricky
        if (self.value > self.maximumValue - self.stepValue) {
            isPlus  = value < self.minimumValue + self.stepValue;
            isMinus = isMinus && !isPlus;
        } else if (self.value < self.minimumValue + self.stepValue) {
            isMinus = value > self.maximumValue - self.stepValue;
            isPlus  = isPlus && !isMinus;
        }
    }
    
    if (isPlus)
        self.plusMinusState = JLTStepperPlus;
    else if (isMinus)
        self.plusMinusState = JLTStepperMinus;
    
    [super setValue:value];
}
@end