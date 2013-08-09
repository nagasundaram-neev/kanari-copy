Given "A facebook user exists who has not registered with Kanari facebook app" do
  create_facebook_non_app_user
end

Given "A facebook user exists who has registered with Kanari facebook app" do
  @facebook_user_token ||= create_facebook_app_user
end
