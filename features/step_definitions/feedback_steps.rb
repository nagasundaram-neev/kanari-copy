When "the contents of $code should be a 5 digit number" do |code|
  code = JSON.parse("[#{JsonSpec.remember(code)}]")[0]
  code.match(/^\d\d\d\d\d$/).should_not be_nil
  Feedback.last.code.should == code
end

Given(/^A feedback exists with the following attributes:$/) do |table|
  Feedback.create!(table.rows_hash)
end
