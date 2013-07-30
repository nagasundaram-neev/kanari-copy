Then(/^a log entry should be created in "(.*?)" table with following:$/) do |log_table, table|
  log_table = eval(log_table.split(/\s/).join)
  p log_table.last
  p User.last
  @log_entry = log_table.where(table.rows_hash).first
  @log_entry.should_not be_nil
  @log_entry.should == log_table.last
end

Then(/^there should not be any log entry in "(.*?)" table with following:$/) do |log_table, table|
  log_table = eval(log_table.split(/\s/).join)
  @log_entry = log_table.where(table.rows_hash).first
  @log_entry.should be_nil
end

And "the code in the log table should be $code" do |code|
  code = JSON.parse("[#{JsonSpec.remember(code)}]")[0]
  @log_entry.code.should == code
end
