require "csv"

class JobMatcher
  attr_reader :jobseeker,
              :job,
              :jobseeker_skills,
              :job_required_skills

  CSV_HEADERS = %w[jobseeker_id jobseeker_name job_id 
                   job_title matching_skill_count matching_skill_percent]

  def self.execute
    recommendations = []

    CSV.foreach("jobseekers.csv", headers: true, converters: :numeric) do |jobseeker|
      CSV.foreach("jobs.csv", headers: true, converters: :numeric) do |job|
        job_matcher = self.new(jobseeker, job)

        next if job_matcher.matching_skills_count == 0

        csv_row = CSV::Row.new(CSV_HEADERS, [jobseeker["id"],
                                   jobseeker["name"],
                                   job["id"],
                                   job["title"],
                                   job_matcher.matching_skills_count,
                                   job_matcher.matching_skills_percent
                                  ])

        recommendations << csv_row
      end
    end

    recommendations.sort_by! { |recm| [recm["jobseeker_id"], -recm["matching_skill_percent"], recm["job_id"]] }

    CSV.open("recommendations.csv", "w") do |csv|
      csv << CSV_HEADERS
      recommendations.each do |recommendation|
        csv << recommendation
      end
    end
  end

  def initialize(jobseeker, job)
    @jobseeker = jobseeker
    @job = job
    @jobseeker_skills = jobseeker["skills"].split(', ')
    @job_required_skills = job["required_skills"].split(', ')
  end

  def matching_skills_count
    matching_skills.count
  end

  def matching_skills_percent
    return 0 if job_required_skills.count == 0

    (matching_skills_count.to_f / job_required_skills.count.to_f * 100.0).round
  end

  def matching_skills
    @matching_skills ||= jobseeker_skills & job_required_skills
  end
end

JobMatcher.execute
