Instructions to Run the project locally:

1. Clone the project locally
2. cd into the cloned folder
3. Run `bundle install`
4. From the root folder run `ruby ./job_matcher.rb`
   - This should create a fresh copy of the recommendations.csv file, which lists the matching sorted job recommendations.
5. from the root folder run `bundle exec rspec spec/job_matcher_spec.rb`
   - This will run the specs that tests the main `execute` method.
