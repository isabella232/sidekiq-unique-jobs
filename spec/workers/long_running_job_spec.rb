# frozen_string_literal: true

RSpec.describe LongRunningJob do
  it_behaves_like "sidekiq with options" do
    let(:options) do
      {
        "queue" => :customqueue,
        "retry" => 10,
        "lock" => :until_and_while_executing,
        "lock_ttl" => 7_200,
      }
    end
  end
  it_behaves_like "a performing worker" do
    let(:args) { %w[one two] }
  end
end
