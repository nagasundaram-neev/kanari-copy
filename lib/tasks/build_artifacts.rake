desc "Move build output to CruiseControl build artifacts directory"
task :build_artifacts  do
  out = ENV['CC_BUILD_ARTIFACTS']
  mkdir_p out unless File.directory? out if out
  mv 'tmp/features.html', "#{out}" if out
  mv 'tmp/rspec.html', "#{out}" if out
end
