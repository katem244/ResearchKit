/*
 Copyright (c) 2015, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "ORKRegistrationStep.h"
#import "ORKHelpers.h"
#import "ORKDefines_Private.h"
#import "ORKAnswerFormat_Private.h"


NSString *const ORKRegistrationFormItemIdentifierEmail = @"ORKRegistrationFormItemEmail";
NSString *const ORKRegistrationFormItemIdentifierPassword = @"ORKRegistrationFormItemPassword";
NSString *const ORKRegistrationFormItemIdentifierConfirmPassword = @"ORKRegistrationFormItemConfirmPassword";
NSString *const ORKRegistrationFormItemIdentifierGivenName = @"ORKRegistrationFormItemGivenName";
NSString *const ORKRegistrationFormItemIdentifierFamilyName = @"ORKRegistrationFormItemFamilyName";
NSString *const ORKRegistrationFormItemIdentifierGender = @"ORKRegistrationFormItemGender";
NSString *const ORKRegistrationFormItemIdentifierDOB = @"ORKRegistrationFormItemDOB";

@implementation ORKRegistrationStep

- (instancetype)initWithIdentifier:(NSString *)identifier
                             title:(NSString *)title
                              text:(NSString *)text
                           options:(ORKRegistrationStepOption)options {
    self = [super initWithIdentifier:identifier title:title text:text];
    if (self) {
        _options = options;
        self.formItems = [self registrationFormItems];
        self.optional = NO;
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                             title:(NSString *)title
                              text:(NSString *)text {
    return [self initWithIdentifier:identifier
                              title:title
                               text:text
                            options:ORKRegistrationStepDefault];
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    return [self initWithIdentifier:identifier
                              title:nil
                               text:nil];
}

- (NSArray *)registrationFormItems {
    NSMutableArray *formItems = [NSMutableArray new];
    
    {
        ORKEmailAnswerFormat *answerFormat = [ORKAnswerFormat emailAnswerFormat];
        
        ORKFormItem *item = [[ORKFormItem alloc] initWithIdentifier:ORKRegistrationFormItemIdentifierEmail
                                                               text:ORKLocalizedString(@"EMAIL_FORM_ITEM_TITLE", nil)
                                                       answerFormat:answerFormat];
        item.placeholder = ORKLocalizedString(@"EMAIL_FORM_ITEM_PLACEHOLDER", nil);
        item.optional = NO;
        
        [formItems addObject:item];
    }
    
    {
        ORKTextAnswerFormat *answerFormat = [ORKAnswerFormat textAnswerFormat];
        answerFormat.multipleLines = NO;
        answerFormat.secureTextEntry = YES;
        answerFormat.autocapitalizationType = UITextAutocapitalizationTypeNone;
        answerFormat.autocorrectionType = UITextAutocorrectionTypeNo;
        answerFormat.spellCheckingType = UITextSpellCheckingTypeNo;

        ORKFormItem *passwordItem = [[ORKFormItem alloc] initWithIdentifier:ORKRegistrationFormItemIdentifierPassword
                                                               text:ORKLocalizedString(@"PASSWORD_FORM_ITEM_TITLE", nil)
                                                       answerFormat:answerFormat];
        passwordItem.placeholder = ORKLocalizedString(@"PASSWORD_FORM_ITEM_PLACEHOLDER", nil);
        passwordItem.optional = NO;
        
        [formItems addObject:passwordItem];
    }
    
    {
        ORKConfirmTextAnswerFormat *confirmAnswerFormat = [[ORKConfirmTextAnswerFormat alloc]
                                                           initWithOriginalItemIdentifier:ORKRegistrationFormItemIdentifierPassword];
        confirmAnswerFormat.multipleLines = NO;
        confirmAnswerFormat.secureTextEntry = YES;
        confirmAnswerFormat.spellCheckingType = UITextSpellCheckingTypeNo;
        confirmAnswerFormat.autocapitalizationType = UITextAutocapitalizationTypeNone;
        confirmAnswerFormat.autocorrectionType = UITextAutocorrectionTypeNo;

        ORKFormItem *confirmItem = [[ORKFormItem alloc] initWithIdentifier:ORKRegistrationFormItemIdentifierConfirmPassword
                                                                      text:ORKLocalizedString(@"CONFIRM_PASSWORD_FORM_ITEM_TITLE", nil)
                                                               answerFormat:confirmAnswerFormat];
        confirmItem.placeholder = ORKLocalizedString(@"CONFIRM_PASSWORD_FORM_ITEM_PLACEHOLDER", nil);
        confirmItem.optional = NO;
        
        [formItems addObject:confirmItem];
    }

    if (!(_options & ORKRegistrationStepDefault)) {
        ORKFormItem *item = [[ORKFormItem alloc] initWithSectionTitle:ORKLocalizedString(@"ADDITIONAL_INFO_SECTION_TITLE", nil)];
        
        [formItems addObject:item];
    }
    
    if (_options & ORKRegistrationStepIncludeGivenName) {
        ORKTextAnswerFormat *answerFormat = [ORKAnswerFormat textAnswerFormat];
        answerFormat.multipleLines = NO;
        
        ORKFormItem *item = [[ORKFormItem alloc] initWithIdentifier:ORKRegistrationFormItemIdentifierGivenName
                                                               text:ORKLocalizedString(@"CONSENT_NAME_GIVEN", nil)
                                                       answerFormat:answerFormat];
        item.placeholder = ORKLocalizedString(@"GIVEN_NAME_ITEM_PLACEHOLDER", nil);
        item.optional = NO;
        
        [formItems addObject:item];
    }
    
    if (_options & ORKRegistrationStepIncludeFamilyName) {
        ORKTextAnswerFormat *answerFormat = [ORKAnswerFormat textAnswerFormat];
        answerFormat.multipleLines = NO;
        
        ORKFormItem *item = [[ORKFormItem alloc] initWithIdentifier:ORKRegistrationFormItemIdentifierFamilyName
                                                               text:ORKLocalizedString(@"CONSENT_NAME_FAMILY", nil)
                                                       answerFormat:answerFormat];
        item.placeholder = ORKLocalizedString(@"FAMILY_NAME_ITEM_PLACEHOLDER", nil);
        item.optional = NO;
        
        [formItems addObject:item];
    }
    
    if (_options & ORKRegistrationStepIncludeGender) {
        NSArray *textChoices = @[[ORKTextChoice choiceWithText:ORKLocalizedString(@"GENDER_FEMALE", nil) value:@"female"],
                                 [ORKTextChoice choiceWithText:ORKLocalizedString(@"GENDER_MALE", nil) value:@"male"],
                                 [ORKTextChoice choiceWithText:ORKLocalizedString(@"GENDER_OTHER", nil) value:@"other"]];
        ORKValuePickerAnswerFormat *answerFormat = [ORKAnswerFormat valuePickerAnswerFormatWithTextChoices:textChoices];
        
        ORKFormItem *item = [[ORKFormItem alloc] initWithIdentifier:ORKRegistrationFormItemIdentifierGender
                                                               text:ORKLocalizedString(@"GENDER_FORM_ITEM_TITLE", nil)
                                                       answerFormat:answerFormat];
        item.placeholder = ORKLocalizedString(@"GENDER_FORM_ITEM_PLACEHOLDER", nil);
        item.optional = NO;
       
        [formItems addObject:item];
    }
    
    if (_options & ORKRegistrationStepIncludeDOB) {
        // Calculate default date (20 years from now).
        NSDate *defaultDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitYear
                                                                       value:-20
                                                                      toDate:[NSDate date]
                                                                     options:kNilOptions];
        
        ORKDateAnswerFormat *answerFormat = [ORKAnswerFormat dateAnswerFormatWithDefaultDate:defaultDate
                                                                                 minimumDate:nil
                                                                                 maximumDate:nil
                                                                                    calendar:nil];
        
        ORKFormItem *item = [[ORKFormItem alloc] initWithIdentifier:ORKRegistrationFormItemIdentifierDOB
                                                               text:ORKLocalizedString(@"DOB_FORM_ITEM_TITLE", nil)
                                                       answerFormat:answerFormat];
        item.placeholder = ORKLocalizedString(@"DOB_FORM_ITEM_PLACEHOLDER", nil);
        item.optional = NO;
        
        [formItems addObject:item];
    }
    
    return formItems;
}

- (ORKTextAnswerFormat *)passwordAnswerFormat {
    ORKFormItem *passwordFormItem = ORKFindInArrayByFormItemId(self.formItems, ORKRegistrationFormItemIdentifierPassword);
    ORKTextAnswerFormat *passwordAnswerFormat = (ORKTextAnswerFormat *)passwordFormItem.answerFormat;
    return passwordAnswerFormat;
}

- (NSString *)passcodeValidationRegex {
    return [self passwordAnswerFormat].validationRegex;
}

- (NSString *)passcodeInvalidMessage {
    return [self passwordAnswerFormat].invalidMessage;
}

- (void)setPasscodeValidationRegex:(NSString *)passcodeValidationRegex {
    [self passwordAnswerFormat].validationRegex = passcodeValidationRegex;
}

- (void)setPasscodeInvalidMessage:(NSString *)passcodeInvalidMessage {
    [self passwordAnswerFormat].invalidMessage = passcodeInvalidMessage;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // The `passcodeValidationRegex` and `passcodeInvalidMessage` properties
        // are transparent properties. The `initWithCoder:` for these properties is
        // defined in the answer format (super).
        ORK_DECODE_INTEGER(aDecoder, options);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    // The `passcodeValidationRegex` and `passcodeInvalidMessage` properties
    // are transparent properties. The `encodeWithCoder:` for these properties is
    // defined in the answer format (super).
    ORK_ENCODE_INTEGER(aCoder, options);
}

- (instancetype)copyWithZone:(NSZone *)zone {
    ORKRegistrationStep *step = [super copyWithZone:zone];
    
    // The `passcodeValidationRegex` and `passcodeInvalidMessage` properties
    // are transparent properties. The `copyWithZone:` for these properties is
    // defined in the answer format (super).
    step->_options = self.options;
    return step;
}

- (BOOL)isEqual:(id)object {
    BOOL isParentSame = [super isEqual:object];
    
    __typeof(self) castObject = object;
    return (isParentSame &&
            self.options == castObject.options);
}

@end
