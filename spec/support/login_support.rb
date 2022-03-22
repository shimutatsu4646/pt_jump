module LoginSupport
  def login_as_trainee(trainee)
    visit new_trainee_session_path
    fill_in "trainee_email", with: trainee.email
    fill_in "trainee_password", with: trainee.password
    click_button "ログイン"
  end

  def login_as_trainer(trainer)
    visit new_trainer_session_path
    fill_in "trainer_email", with: trainer.email
    fill_in "trainer_password", with: trainer.password
    click_button "ログイン"
  end
end
