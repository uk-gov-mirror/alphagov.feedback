class EmailSurvey
  class NotFoundError < StandardError; end
  attr_accessor :id, :url, :start_time, :end_time, :name
  def initialize(id:, url:, start_time:, end_time:, name:nil)
    self.id = id
    self.url = url
    self.start_time = start_time
    self.end_time = end_time
    self.name = name.present? ? name : id.humanize
  end

  def active?(at: Time.zone.now)
    at.between? start_time, end_time
  end

  def self.all
    SURVEYS.values
  end

  def self.find(id)
    SURVEYS.fetch(id) { |not_found_id| raise NotFoundError.new(not_found_id) }
  end

  SURVEYS = Hash[
    [
      new(
        id: 'education_email_survey',
        url: 'https://www.smartsurvey.co.uk/s/gov-uk/',
        start_time: Time.zone.parse("2017-03-06").beginning_of_day,
        end_time: Time.zone.parse("2017-03-10").end_of_day,
        name: 'education user research'
      ).freeze,
    ].map { |s| [s.id, s] }
  ].freeze
end
