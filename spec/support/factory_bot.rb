# typed: ignore
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end
end

# don't run before suite because we need to stub all requests before linting
# this also won't run if only one file is tested, which is good.
# rubocop:disable RSpec/DescribeClass
describe 'Factory Bot' do
  it 'lints factories successfully' do
    DatabaseCleaner.start
    # Only run factory bot lint on one of the CI nodes.
    FactoryBot.lint unless ENV['CI'] && ENV['CI_NODE_INDEX'] != 1
  ensure
    DatabaseCleaner.clean
  end
end
# rubocop:enable RSpec/DescribeClass
