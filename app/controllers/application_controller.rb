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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :age, :gender, :introduction, :start_time, :end_time, :dm_allowed])
  end
end
