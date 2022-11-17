//
//  CameraViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/17.
//

import UIKit
import Vision
// 얼굴 인식, 텍스트 읽기, 이미지 등록, 트랙킹
import AVFoundation
// 카메라 사용
import SafariServices
// 사파리 사용

class CameraViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    
    lazy var detectBarcodeRequest = VNDetectBarcodesRequest { request, error in
        guard error == nil else {
            self.showAlert(
                withTitle: "Barcode error",
                message: error?.localizedDescription ?? "error")
            return
        }
        self.processClassification(request)
        
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
 
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //MARK: 중요한 부분! 멈춰야 한다.
        //메모리 자원을 아껴쓰자
        captureSession.stopRunning()
    }
    
    
    override func viewDidLoad() {
        title = "QR코드 인식"
        setupNav()
        checkPermissions()
        setupCameraLiveView()
    }
}

extension CameraViewController {
    private func setupNav() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    
    
    
    private func setupCameraLiveView() {
        captureSession.sessionPreset = .hd1280x720
        // captureSession은 캡쳐 활동 관리 / 디바이스에서 나오는 아웃풋인 데이터 흐름을 조정 가능
        
        //MARK: making input
        //1 휴대폰 뒤 카메라에 대한 정보
        let videoDevice = AVCaptureDevice
            .default(.builtInWideAngleCamera, for: .video, position: .back)
        
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
        // TODO: Set video sample rate
        captureOutput.videoSettings =
        [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        // 포맷 형식 32-bit BGBA
        captureOutput.setSampleBufferDelegate(
            // 버퍼 안 새로운 이미지를 사용할 수 있을 때, Vision은 delegate 메소드를 부른다
            self,
            queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        
        configurePreviewLayer()
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {return}
            self.captureSession.startRunning()
        }
        
        // 카메라 세션 시작 important: 카메라 세션 다시 중지하는 것을 잊지 말자
    }
    
    
    private func configurePreviewLayer() {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        cameraPreviewLayer.frame = view.safeAreaLayoutGuide.layoutFrame
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    private func processClassification(_ request: VNRequest) {
        // 처리된 요청 결과를 분석하기 위함
        
        // 1 바코드 같은 이미지들의 이미지를 request에서 받아오기
        guard let barcodes = request.results else {return}
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.view.layer.sublayers?.removeSubrange(1...)
            
            //2 바코드들을 분석
            for barcode in barcodes {
                guard
                    // 이미지가 있을 확률 & qr코드 체크
                    let potentialQRCode = barcode as? VNBarcodeObservation,
                    potentialQRCode.symbology == .qr, // qr코드 확인
                    potentialQRCode.confidence > 0.9 // qr코드 맞을 확률 90% 이상만 가져오기
                else { return }
                
                //3 여기다가 다음 수행할 것 작성 (바코드 확인 완료하면 할 것)
//                self.showAlert(
//                    withTitle: potentialQRCode.symbology.rawValue,
//                    message: String(potentialQRCode.confidence))
                
                self.observationHandler(payload: potentialQRCode.payloadStringValue)
 
                
            }
        }
    }
    
    //MARK: Safari 키기
    private func observationHandler(payload: String?){
        // 링크를 열자
        guard
            let payloadString = payload,
            let url = URL(string: payloadString),
            ["http","http"].contains(url.scheme?.lowercased())
        else { return }
        
        //2
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        //3

        searchBarcode(url, config)
    }
    
    private func searchBarcode(_ url: URL,_ config: SFSafariViewController.Configuration) {
        let host = url.absoluteString.onlyHost
        let alert = UIAlertController(title: host, message:
         "이 사이트에 접근하시겠습니까?", preferredStyle: .alert)
        let action = UIAlertAction(title: "네", style: .default, handler: { [weak self]_ in
            guard let self = self else { return }
            let safariVC = SFSafariViewController(url: url, configuration: config)
            safariVC.delegate = self
            self.present(safariVC, animated: true)
        })
        let cancel = UIAlertAction(title: "아니오", style: .cancel, handler: nil )
        alert.addAction(cancel)
        alert.addAction(action)
               
        present(alert, animated: true, completion: nil)
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

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            // 플립 북 페이지처럼 샘플 버퍼에서 이미지를 가져옴
        
        let imageRequestHandler = VNImageRequestHandler(
            //VNImageRequestHandler 해당 이미지를 사용하여 새로 만들기
            cvPixelBuffer: pixelBuffer,
            orientation: .right)
        
        do {
            try imageRequestHandler.perform([detectBarcodeRequest])
        } catch {
            print(error)
        }
    }
    
 
}

extension CameraViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // 끝나면 다시 되돌리기
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {return}
            self.captureSession.startRunning()
        }
    }
    
}


extension String {
    var onlyHost: String? {
        let url = URL(string: self)
        return url?.host
    }
}
