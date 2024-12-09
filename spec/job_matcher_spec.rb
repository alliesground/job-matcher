require 'pry'
require './job_matcher'

describe JobMatcher do
  let(:test_file) { "test_recommendations.csv" }

  describe ".execute" do
    let(:jobseeker) { CSV::Row.new ['id', 'name', 'skills'], [1,'Test1', "Rails, Ruby"] }
    let(:job1) { CSV::Row.new ['id', 'title', 'required_skills'], [1,'TestJob1', "Rails, Ruby, React"] }
    let(:job2) { CSV::Row.new ['id', 'title', 'required_skills'], [2,'TestJob2', "Python, Ruby, Rust"] }

    it "returns csv of recommended matching jobs" do
      allow(CSV).to receive(:foreach) { |&block1|
        allow(CSV).to receive(:foreach) {|&block2| 
          block2.call(job1)
          block2.call(job2)
        }

        block1.call(jobseeker)
      }

      test_csv = CSV.open(test_file, "w")
      allow(CSV).to receive(:open).and_yield(test_csv)

      res = described_class.execute

      expect(res.first["job_id"]).to eq job1["id"]
      expect(res.last["job_id"]).to eq job2["id"]
    end
  end
end
