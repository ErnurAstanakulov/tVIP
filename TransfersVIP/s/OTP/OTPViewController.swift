//
//  OTPViewController.swift
//  DigitalBank
//
//  Created by Zhalgas Baibatyr on 26/04/2018.
//

class OTPViewController: CodeBasedAuthFactorViewController {

    let otpFormView = CodeBasedAuthFactorFormView()
    let syncOTPFormView = SyncOTPFormView()
    let viewModel = OTPViewModel()
    
    override func loadView() {
        super.loadView()
        
        setContainerSubview(otpFormView)
        otpFormView.titleLabel.text = "Подтвердить: OTP"
        otpFormView.additionalButton.setTitle("Синхронизировать", for: .normal)
        otpFormView.additionalButton.backgroundColor = .white
        otpFormView.additionalButton.setTitleColor(AppData.Color.technolygedBlackGray.uiColor, for: .normal)
        otpFormView.additionalButton.layer.borderWidth = 1
        otpFormView.codeTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        otpFormView.sendCodeButton.addTarget(self, action: #selector(sendCodeToServer), for: .touchUpInside)
        otpFormView.additionalButton.addTarget(self, action: #selector(setSyncOTPFormView), for: .touchUpInside)
        
        syncOTPFormView.titleLabel.text = "Синхронизировать: OTP"
        syncOTPFormView.additionalButton.setTitle("Отмена", for: .normal)
        syncOTPFormView.additionalButton.layer.borderWidth = 1
        syncOTPFormView.codeTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        syncOTPFormView.secondCodeTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        syncOTPFormView.sendCodeButton.addTarget(self, action: #selector(syncOTP), for: .touchUpInside)
        syncOTPFormView.additionalButton.addTarget(self, action: #selector(closeSyncOTPForm), for: .touchUpInside)
        
//        // AutomaticUserCredentials: START
//        #if DEBUG || TEST
//        AutomaticUserCredentials.requestOTP { [weak self] in
//            DispatchQueue.main.async {
//                self?.otpFormView.codeTextField.text = AutomaticUserCredentials.otpCode
//                self?.viewModel.otpCode = AutomaticUserCredentials.otpCode
//            }
//        }
//        #endif
//        // AutomaticUserCredentials: END
    }
    
    @objc private func setSyncOTPFormView() {
        setContainerSubview(syncOTPFormView)
    }
    
    @objc private func sendCodeToServer(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            self.performOnCompletion?(true, nil)
        })
    }
    
    @objc private func syncOTP(_ sender: UIButton) {
        Loader.shared.show()
        viewModel.syncAndPassOTPAuthFactor { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                guard let otpViewController = self else {
                    return
                }
                
                Loader.shared.hide()
                guard success else {
                    otpViewController.performOnCompletion?(false, errorMessage)
                    return
                }
                
                otpViewController.setContainerSubview(otpViewController.otpFormView)
            }
        }
    }
    
    @objc private func closeSyncOTPForm(_ sender: UIButton) {
        setContainerSubview(otpFormView)
    }
    
    @objc private func textFieldEditingDidChange(_ sender: UITextField) {
        switch sender {
        case otpFormView.codeTextField:
            viewModel.otpCode = otpFormView.codeTextField.text
        case syncOTPFormView.codeTextField:
            viewModel.previousToken = syncOTPFormView.codeTextField.text
        case syncOTPFormView.secondCodeTextField:
            viewModel.nextToken = syncOTPFormView.secondCodeTextField.text
        default:
            break
        }
    }
}
