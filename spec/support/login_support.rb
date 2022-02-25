module LoginSupport
  def login(trainee)
    visit new_trainee_session_path
    fill_in "trainee_email", with: trainee.email
    fill_in "trainee_password", with: trainee.password
    click_button "ログイン"
  end
end
