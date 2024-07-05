import XCTest
@testable import ValidationKit

final class ValidatorTests: XCTestCase {

    func testBaseValidationValidInput() {
        let input = "Name$"
        XCTAssertTrue(BaseValidator().isValid(input))
    }

    func testBaseValidationInvalidInput() {
        let input = "333 🏆"
        XCTAssertFalse(BaseValidator().isValid(input))
    }

    func testBaseValidationInvalidNonAsciiInput() {
        let input = "Stëéé"
        XCTAssertFalse(BaseValidator().isValid(input))
    }

    func testFullNameValidationValid() {
        let input = "Patrick Smith"
        XCTAssertTrue(FullNameValidator().isValid(input))
    }

    func testFullNameValidationInvalid() {
        let input = "J Ehðŵf"
        let result = FullNameValidator().validate(input)
        switch result {
        case .invalid(let errors):
            XCTAssertNotNil(errors)
            XCTAssertEqual(errors.count, 2)
        case .valid:
            XCTFail("Should not be valid")
        }
        XCTAssertFalse(FullNameValidator().isValid(input))
    }

    func testEmailValidationValidEmail() {
        let input = "test@gmail.com"
        XCTAssertTrue(EmailValidator().isValid(input))
    }

    func testEmailValidationInvalidEmail() {
        let input = "test@gmailcom"
        XCTAssertFalse(EmailValidator().isValid(input))
    }

    func testPhoneValidation_Hyphens_ValidNumber() {
        let input = "444-555-5745"
        XCTAssertTrue(PhoneValidator(style: .hyphens).isValid(input))
    }

    func testPhoneValidation_Hyphens_InvalidNumber() {
        let input = "222333$444"
        XCTAssertFalse(PhoneValidator(style: .hyphens).isValid(input))
    }

    func testPhoneValidation_AreaCodeParentheses_ValidNumber() {
        let input = "(444) 555-5745"
        XCTAssertTrue(PhoneValidator(style: .areaCodeParentheses).isValid(input))
    }

    func testPhoneValidation_AreaCodeParentheses_InvalidNumber() {
        let input = "(222) 333-$444"
        XCTAssertFalse(PhoneValidator(style: .areaCodeParentheses).isValid(input))
    }

    func testSSNValidationValidSSN() {
        let input = "123-44-5555"
        XCTAssertTrue(SSNValidator().isValid(input))
    }

    func testSSNValidationInvalidSSN() {
        let input = "444-555-574"
        XCTAssertFalse(SSNValidator().isValid(input))
    }

    func testZipValidationValidZip() {
        let input = "10012"
        XCTAssertTrue(ZipValidator().isValid(input))
    }

    func testZipValidationInvalidZip() {
        let input = "112"
        XCTAssertFalse(ZipValidator().isValid(input))
    }

    func testCCVValidationValid() {
        let input = "344"
        XCTAssertTrue(CCVValidator().isValid(input))
    }

    func testCCVValidationInvalid() {
        let input = "113332"
        XCTAssertFalse(CCVValidator().isValid(input))
    }

    func testLastFourSSNValidationValid() {
        let input = "3322"
        XCTAssertTrue(LastFourSSNValidator().isValid(input))
    }

    func testLastFourSSNValidationInvalid() {
        let input = "432"
        XCTAssertFalse(LastFourSSNValidator().isValid(input))
    }

    func testStateValidationValid() {
        let input = "NY"
        XCTAssertTrue(StateValidator().isValid(input))
    }

    func testStateValidationInvalid() {
        let input = "XSAA"
        XCTAssertFalse(StateValidator().isValid(input))
    }
}

