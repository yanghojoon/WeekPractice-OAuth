import UIKit
import KakaoSDKUser


class ViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func touchUpKakaoTalkLoginButton(_ sender: UIButton) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            print("로그인 사용 가능")
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in // 여기서 클로저를 타지 않고 바로 내려감. 그런데 앱에선 카톡 화면으로 넘어감
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    UserApi.shared.me { user, error in
                        if let error = error {
                            print(error)
                        } else {
                            let profileImageURL = user?.kakaoAccount?.profile?.profileImageUrl
                            let nickname = user?.kakaoAccount?.profile?.nickname
                            
                            self.presentProfile(profileURL: profileImageURL, nickname: nickname)
                        }
                    }
                }
            }
        } else {
            print("로그인 실패") // 시뮬레이터에선 앱이 없어서 지금 계속 실패를 하는 중
        }
    }
    
    private func presentProfile(profileURL: URL?, nickname: String?) {
        guard let imageData = try? Data(contentsOf: profileURL!) else { return }
        
        profileImageView.image = UIImage(data: imageData)
        nicknameLabel.text = nickname
    }
    
}
