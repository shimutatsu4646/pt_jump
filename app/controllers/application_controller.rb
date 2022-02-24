class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # def after_sign_in_path_for(resource)
  #   flash[:notice] = "ログインに成功しました"
  #   trainee_path(current_trainee.id)
  # end

  # サインアウト後のリダイレクト先をトップページへ
  # def after_sign_out_path_for(resource)
  #   flash[:alert] = "ログアウトしました"
  #   root_path
  # end

  protected

  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:profile_change) do |trainee|
    #   trainee.permit(:name, :age)
    #   # https://github.com/heartcombo/devise/blob/8593801130f2df94a50863b5db535c272b00efe1/lib/devise/parameter_sanitizer.rb#L28
    # できないかも
    # endf
  end
end
