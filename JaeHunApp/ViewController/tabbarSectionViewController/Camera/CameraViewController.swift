//
//  CameraViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/17.
//

import UIKit
import AVFoundation
// 카메라 사용
import SafariServices
// 사파리 사용

class CameraViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //MARK: 중요한 부분! 멈춰야 한다.
        captureSession.stopRunning()
    }
    
    //MARK: 실행 허가
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        // 1
        case .notDetermined: // 아직 결정 안함
          AVCaptureDevice.requestAccess(for: .video) { [self] granted in // Alert
            if !granted {
              showPermissionsAlert()
            }
          }

        // 2
        case .denied, .restricted:
          showPermissionsAlert()

        // 3
        default:
          return
        }
    }
    
    override func viewDidLoad() {
        setupLayout()
    }
}

extension CameraViewController {
    private func setupCameraLiveView() {
        captureSession.sessionPreset = .hd1280x720
        // captureSession은 캡쳐 활동 관리 / 디바이스에서 나오는 아웃풋인 데이터 흐름을 조정 가능
        
        //MARK: making input
        //1 휴대폰 뒤 카메라에 대한 정보
        let videoDevice = AVCaptureDevice
            .default(.builtInLiDARDepthCamera, for: .video, position: .back)
        
        //2 카메라를 사용할 수 있는지 먼저 체크하고
        guard
            let device = videoDevice,
            let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(videoDeviceInput)
        else{
            showAlert(withTitle: "카메라를 찾을 수 없습니다.", message: "핸드폰 카메라에 문제가 있는지 확인해보세요")
            return
        }
        
        //3 집어 넣기
        captureSession.addInput(videoDeviceInput)
        
        //MARK: making output
        let captureOutput = AVCaptureVideoDataOutput()
        // 비디오를 녹화하고 처리를 위해 비디오 프레임에 대한 엑세스를 제공하는 캡처 출력
        captureSession.addOutput(captureOutput)
        
        configurePreviewLayer()
        
        captureSession.startRunning()
        // 카메라 세션 시작 important: 카메라 세션 다시 중지하는 것을 잊지 말자
    }
    
    private func configurePreviewLayer() {
        
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
    }
    
    //MARK: Alert을 사용
    private func showAlert(withTitle title: String, message: String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }
    
    private func showPermissionsAlert() {
        showAlert(
            withTitle: "카메라 접근",
            message: "유저의 카메라를 사용하기 위해 설정에서 접근권한을 설정하셔야 합니다.")
    }
}
