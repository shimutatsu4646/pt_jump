# module ControllerMacros
#   def login_trainee
#     before(:each) do
#       # 下記の行でルーティングを設定する。
#       @request.env["devise.mapping"] = Devise.mappings[:trainee]
#       trainee = FactoryBot.create(:trainee)
#       # trainee.confirm!    # traineeモデルにconfirmable moduleを使用する場合、コメントアウトする
#       sign_in trainee
#     end
#   end
# end
