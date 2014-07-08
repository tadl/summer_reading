class CsvMailer < ActionMailer::Base
  default from: "tech@tadl.org"

  def csv_email(user, content, csv_description)
  	@description = csv_description
  	attachments['patrons.csv'] = content
  	mail to: user, subject: 'Summer Reading CSV'
  end

end
