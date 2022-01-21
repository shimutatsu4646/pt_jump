# require 'rails_helper'
# RSpec.describe "Trainees_Sessions" do
#   it "トレーニーがサインイン・サインアウトしたときに、期待通りのページに遷移すること" do
#     trainee = create(:trainee)

#     sign_in trainee
#     get root_path
#     expect(response).to render_template(:index)
#     sign_out trainee
#     get root_path
#     expect(response).not_to render_template(:index)
#   end
# end
